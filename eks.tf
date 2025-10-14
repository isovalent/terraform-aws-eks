// Copyright 2022 Isovalent, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// Used to list AMIs according to the specified filter.
data "aws_ami" "workers" {
  for_each    = var.self_managed_node_groups
  most_recent = true
  owners      = var.ami_owners
  filter {
    name = "name"
    values = [
      each.value.ami_name_filter
    ]
  }
}

// Used to make sure the VPC has been created and introduce proper dependencies between 'data' blocks.
data "aws_vpc" "vpc" {
  id = var.vpc_id
}


// Used to wait for the subnets that should be used for the EKS control-plane to exist in two different AZs.
// Unfortunately there doesn't seem to be a better way to do this in Terraform.
resource "null_resource" "wait_for_control_plane_subnets" {
  provisioner "local-exec" {
    command = "${path.module}/scripts/wait-for-control-plane-subnets.sh ${data.aws_vpc.vpc.id} ${var.region}"
  }
}

// Used to list all subnets usable for the EKS control-plane.
data "aws_subnets" "eks_control_plane" {
  depends_on = [
    null_resource.wait_for_control_plane_subnets,
  ]
  filter {
    name = "vpc-id"
    values = [
      data.aws_vpc.vpc.id
    ]
  }
  filter {
    name = "tag:eks-control-plane"
    values = [
      "true"
    ]
  }
}

// Used to list all private subnets in the VPC.
data "aws_subnets" "private" {
  depends_on = [
    null_resource.wait_for_control_plane_subnets,
  ]
  filter {
    name = "vpc-id"
    values = [
      data.aws_vpc.vpc.id
    ]
  }
  filter {
    name = "tag:type"
    values = [
      "private"
    ]
  }
}

// Used to list all public subnets in the VPC.
data "aws_subnets" "public" {
  filter {
    name = "vpc-id"
    values = [
      data.aws_vpc.vpc.id
    ]
  }
  filter {
    name = "tag:type"
    values = [
      "public"
    ]
  }
}

// EKS cluster.
module "main" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.3.1"

  addons                                   = var.cluster_addons != null ? { for k, v in var.cluster_addons : k => v if k != "coredns" } : null // The set of addons to enable on the EKS cluster, excluding coredns which is managed separately.
  enable_cluster_creator_admin_permissions = true                                                                                              // Give access to person/bot running terraform access to the cluster
  endpoint_public_access                   = true
  endpoint_public_access_cidrs             = var.external_source_cidrs                                                                                                       // Enable public access to the Kubernetes API server.
  authentication_mode                      = "API_AND_CONFIG_MAP"                                                                                                            // Authentication mode for EKS. Will move to API only in v21 of the upstream module
  name                                     = var.name                                                                                                                        // The name of the EKS cluster.
  service_ipv4_cidr                        = var.cluster_service_ipv4_cidr                                                                                                   // The CIDR block to assign Kubernetes service IP addresses from.
  kubernetes_version                       = var.kubernetes_version                                                                                                          // The version of EKS to use.
  control_plane_subnet_ids                 = length(var.control_plane_subnet_ids) > 0 ? var.control_plane_subnet_ids : data.aws_subnets.eks_control_plane.ids                // The set of all subnets in which the EKS control-plane can be placed.
  enable_irsa                              = true                                                                                                                            // Enable IAM roles for service accounts. These are used extensively.
  subnet_ids                               = var.include_public_subnets ? setunion(data.aws_subnets.private.ids, data.aws_subnets.public.ids) : data.aws_subnets.private.ids // The set of all subnets in which worker nodes can be placed.
  tags                                     = var.tags                                                                                                                        // The tags placed on the EKS cluster.
  vpc_id                                   = data.aws_vpc.vpc.id
  create_iam_role                          = var.create_iam_role
  iam_role_arn                             = var.iam_role_arn
  create_node_iam_role                     = var.create_node_iam_role


  self_managed_node_groups = { // The set of self-managed node groups.
    for key, g in var.self_managed_node_groups :
    key => {
      ami_type              = g.ami_type                                                                                                    // The AMI family to use for worker nodes, "AL2_x86_64" etc. https://docs.aws.amazon.com/eks/latest/APIReference/API_CreateNodegroup.html#API_CreateNodegroup_RequestBody
      ami_id                = data.aws_ami.workers[key].image_id                                                                            // The ID of the AMI to use for worker nodes.
      create_security_group = false                                                                                                         // Don't create a dedicated security group. A common one is used instead.
      desired_size          = g.min_nodes                                                                                                   // Set the desired size of the worker group to the minimum.
      key_name              = g.key_name != "" ? g.key_name : aws_key_pair.ssh_access.key_name                                              // The name of the SSH key to use for the nodes.
      bootstrap_extra_args  = g.ami_type == "BOTTLEROCKET_x86_64" ? g.kubelet_extra_args : "--kubelet-extra-args '${g.kubelet_extra_args}'" // The set of extra arguments to the bootstrap script. Used to pass extra flags to the kubelet, and namely to set labels and taints. For bottlerocket this needs to be a TOML(https://bottlerocket.dev/en/os/1.19.x/api/settings/kubernetes/) since it doesn't use kubelet to pass the args.
      iam_role_additional_policies = {                                                                                                      // The set of additional policies to add to the worker group IAM role.
        for index, arn in var.worker_node_additional_policies :
        arn => arn
      }
      max_size                     = g.max_nodes                                                      // The maximum size of the worker group.
      min_size                     = g.min_nodes                                                      // The minimum size of the worker group.
      name                         = "${var.name}-${g.name}"                                          // Prefix the worker group name with the name of the EKS cluster.
      instance_type                = g.instance_type                                                  // The instance type to use for worker nodes.
      pre_bootstrap_user_data      = g.pre_bootstrap_user_data                                        // The pre-bootstrap user data to use for worker nodes.
      post_bootstrap_user_data     = g.post_bootstrap_user_data                                       // The pre-bootstrap user data to use for worker nodes.
      cloudinit_pre_nodeadm        = g.cloudinit_pre_nodeadm != null ? g.cloudinit_pre_nodeadm : []   // The set of cloud-init directives to run before nodeadm.
      cloudinit_post_nodeadm       = g.cloudinit_post_nodeadm != null ? g.cloudinit_post_nodeadm : [] // The set of cloud-init directives to run after nodeadm.
      iam_role_additional_policies = g.iam_role_additional_policies
      create_iam_instance_profile  = g.create_iam_instance_profile
      iam_instance_profile_arn     = g.iam_instance_profile_arn
      create_access_entry          = g.create_access_entry
      iam_role_arn                 = g.iam_role_arn
      subnet_ids                   = length(g.subnet_ids) > 0 ? g.subnet_ids : data.aws_subnets.private.ids // Only place nodes in private subnets. This may change in the future.
      tags = merge(g.extra_tags, {                                                                          // The set of tags placed on each worker node.
        "k8s.io/cluster-autoscaler/enabled"     = "true",                                                   // Required by the cluster autoscaler.
        "k8s.io/cluster-autoscaler/${var.name}" = "owned",                                                  // Required by the cluster autoscaler.
      })
      block_device_mappings = {
        (g.root_volume_id) = {
          device_name = g.root_volume_id
          ebs = {
            volume_size           = g.root_volume_size // The size of the root volume of each worker node.
            volume_type           = g.root_volume_type // The type of the root volume of each worker node.
            encrypted             = true               // Encrypt the volume.
            delete_on_termination = true               // Delete the volume on instance termination.
          }
        }
      }
      metadata_options = {
        http_endpoint               = "enabled"
        http_protocol_ipv6          = "disabled"
        http_put_response_hop_limit = 2
        instance_metadata_tags      = "disabled"
        http_tokens                 = var.allow_imdsv1 ? "optional" : "required"
      }
    }
  }
}

// Make sure the kubeconfig file always exists.
// This is necessary because running 'terraform init' may replace the directory containing it when run.
resource "null_resource" "kubeconfig" {
  depends_on = [
    module.main.cluster_arn // Do not run before the EKS cluster is up.
  ]
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${var.name} --region ${var.region}"
    environment = {
      CLUSTER_NAME = var.name,
      KUBECONFIG   = local.path_to_kubeconfig_file,
      REGION       = var.region,
    }
  }
}

resource "null_resource" "wait_for_node_ready" {
  count = var.cluster_addons == null || contains(keys(var.cluster_addons), "coredns") ? 1 : 0
  depends_on = [
    null_resource.kubeconfig, // Do not run before the kubeconfig file is created.
  ]

  provisioner "local-exec" {
    command = <<-EOT
      set -e
      echo "Waiting for nodes to join the cluster..."
      KUBECONFIG=${local.path_to_kubeconfig_file}
      
      # Wait for at least one node to appear (up to 10 minutes)
      timeout=600
      elapsed=0
      while [ $elapsed -lt $timeout ]; do
        node_count=$(kubectl --kubeconfig=$KUBECONFIG get nodes --no-headers 2>/dev/null | wc -l || echo "0")
        if [ "$node_count" -gt "0" ]; then
          echo "Found $node_count node(s), waiting for them to be ready..."
          break
        fi
        echo "No nodes found yet, waiting... ($elapsed/$timeout seconds)"
        sleep 10
        elapsed=$((elapsed + 10))
      done
      
      if [ "$node_count" -eq "0" ]; then
        echo "ERROR: No nodes joined the cluster within $timeout seconds"
        exit 1
      fi
      
      # Now wait for all nodes to be ready
      kubectl --kubeconfig=$KUBECONFIG wait --for=condition=Ready nodes --all --timeout=15m

      #Sleep another two minutes to give CNI time to settle
      sleep 120
    EOT
  }
}

resource "aws_eks_addon" "coredns" {
  count        = var.cluster_addons == null || contains(keys(var.cluster_addons), "coredns") ? 1 : 0
  depends_on   = [null_resource.wait_for_node_ready]
  cluster_name = module.main.cluster_name
  addon_name   = "coredns"
}

resource "aws_eks_addon" "kube_proxy" {
  count        = var.cluster_addons == null ? 1 : 0
  cluster_name = module.main.cluster_name
  addon_name   = "kube-proxy"
}

