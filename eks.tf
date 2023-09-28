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
  version = "19.4.2"

  create_aws_auth_configmap      = false                                                                                                                           // Create the 'kube-system/aws-auth' configmap as we're using self-managed node groups.
  cluster_endpoint_public_access = true                                                                                                                            // Enable public access to the Kubernetes API server.
  cluster_name                   = var.name                                                                                                                        // The name of the EKS cluster.
  cluster_service_ipv4_cidr      = var.cluster_service_ipv4_cidr                                                                                                   // The CIDR block to assign Kubernetes service IP addresses from. 
  cluster_version                = var.kubernetes_version                                                                                                          // The version of EKS to use.
  control_plane_subnet_ids       = length(var.control_plane_subnet_ids) > 0 ? var.control_plane_subnet_ids : data.aws_subnets.eks_control_plane.ids                // The set of all subnets in which the EKS control-plane can be placed.
  enable_irsa                    = true                                                                                                                            // Enable IAM roles for service accounts. These are used extensively.
  manage_aws_auth_configmap      = false                                                                                                                           // Do not have the upstream module manage the 'aws-auth' configmap as apparently there may be some issues with authentication.
  subnet_ids                     = var.include_public_subnets ? setunion(data.aws_subnets.private.ids, data.aws_subnets.public.ids) : data.aws_subnets.private.ids // The set of all subnets in which worker nodes can be placed.
  tags                           = var.tags                                                                                                                        // The tags placed on the EKS cluster.
  vpc_id                         = data.aws_vpc.vpc.id                                                                                                             // The ID of the VPC in which to create the cluster.

  self_managed_node_groups = { // The set of self-managed node groups.
    for key, g in var.self_managed_node_groups :
    key => {
      platform              = coalesce(g.platform, "linux")                                                        // Platform is optional, linux is used if omitted, also can be bottlerocket or windows https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/user_data.md#user-data--bootstrapping 
      ami_id                = data.aws_ami.workers[key].image_id                                                   // The ID of the AMI to use for worker nodes.
      create_security_group = false                                                                                // Don't create a dedicated security group. A common one is used instead.
      desired_size          = g.min_nodes                                                                          // Set the desired size of the worker group to the minimum.
      key_name              = aws_key_pair.ssh_access.key_name                                                     // The name of the SSH key to use for the nodes.
      bootstrap_extra_args  = g.platform == "bottlerocket" ? "" : "--kubelet-extra-args '${g.kubelet_extra_args}'" // The set of extra arguments to the bootstrap script. Used to pass extra flags to the kubelet, and namely to set labels and taints. Ignored for bottlerocket.
      iam_role_additional_policies = {                                                                             // The set of additional policies to add to the worker group IAM role.
        for index, arn in var.worker_node_additional_policies :
        arn => arn
      }
      max_size                     = g.max_nodes                // The maximum size of the worker group.
      min_size                     = g.min_nodes                // The minimum size of the worker group.
      name                         = "${var.name}-${g.name}"    // Prefix the worker group name with the name of the EKS cluster.
      instance_type                = g.instance_type            // The instance type to use for worker nodes.
      pre_bootstrap_user_data      = g.pre_bootstrap_user_data  // The pre-bootstrap user data to use for worker nodes.
      post_bootstrap_user_data     = g.post_bootstrap_user_data // The pre-bootstrap user data to use for worker nodes.
      iam_role_additional_policies = g.iam_role_additional_policies
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

resource "null_resource" "update_aws_auth_configmap" {
  count = var.manage_aws_auth_configmap ? 1 : 0

  depends_on = [
    null_resource.kubeconfig,
  ]

  provisioner "local-exec" {
    command = <<EOF
cat <<EOT | kubectl -n kube-system apply -f-
${module.main.aws_auth_configmap_yaml}
EOT
EOF
    environment = {
      KUBECONFIG = local.path_to_kubeconfig_file,
    }
  }
}

resource "null_resource" "disable_aws_vpc_cni_plugin" {
  count = var.disable_aws_vpc_cni_plugin ? 1 : 0

  depends_on = [
    null_resource.kubeconfig,
  ]

  provisioner "local-exec" {
    command = <<EOF
kubectl -n kube-system patch ds aws-node -p '{"spec":{"template":{"spec":{"nodeSelector":{"io.cilium/aws-node-enabled":"true"}}}}}'
EOF
    environment = {
      KUBECONFIG = local.path_to_kubeconfig_file,
    }
  }
}

