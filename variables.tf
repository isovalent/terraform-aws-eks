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

variable "allow_imdsv1" {
  default     = false
  description = "Whether to allow IMDSv1 access (insecure)."
  type        = bool
}

variable "ami_owners" {
  default = [
    "099720109477", // Canonical
    "679593333241", // AWS Marketplace
    "amazon",
    "self",
  ]
  description = "The list of acceptable owners of AMIs to be used for worker nodes."
  type        = list(string)
}

variable "aws_load_balancer_controller_oidc_fully_qualified_subjects" {
  description = "The list of trusted resources which can assume the 'aws-load-balancer-controller' role using OpenID Connect."
  default     = []
  type        = list(string)
}

variable "aws_ebs_csi_driver_oidc_fully_qualified_subjects" {
  description = "The list of trusted resources which can assume the 'aws-ebs-csi-driver' role using OpenID Connect."
  default     = []
  type        = list(string)
}

variable "cert_manager_oidc_fully_qualified_subjects" {
  description = "The list of trusted resources which can assume the 'cert-manager' role using OpenID Connect."
  default     = []
  type        = list(string)
}

variable "cluster_autoscaler_oidc_fully_qualified_subjects" {
  description = "The list of trusted resources which can assume the 'cluster-autoscaler' role using OpenID Connect."
  default     = []
  type        = list(string)
}

variable "cluster_service_ipv4_cidr" {
  description = "The CIDR block to assign Kubernetes service IP addresses from."
  default     = null
  type        = string
}

variable "cluster_addons" {
  description = "Map of cluster addon configurations."
  default     = null
  type        = any
}

variable "control_plane_subnet_ids" {
  default     = []
  description = "Can be used to override the list of subnet IDs to use for the EKS control-plane. If not defined, subnets tagged with 'eks-control-plane: true' will be used."
  type        = list(string)
}

variable "echo_server_instance_enabled" {
  description = "Whether to create an EC2 instance outside the cluster that can act as 'echo-server'."
  type        = bool
  default     = false
}

variable "echo_server_instance_user_data" {
  default     = ""
  description = "The user data script to use for the 'echo-server' instance."
  type        = string
}

variable "external_dns_oidc_fully_qualified_subjects" {
  description = "The list of trusted resources which can assume the 'external-dns' role using OpenID Connect."
  default     = []
  type        = list(string)
}

variable "include_public_subnets" {
  default     = true
  description = "Whether to include public subnets in the list of subnets usable by the EKS cluster."
  type        = bool
}

variable "kubernetes_version" {
  description = "The version of Kubernetes/EKS to use."
  type        = string
}

variable "log_shipping_bucket_name" {
  default     = ""
  description = "The name of the S3 bucket that will be used to store logs."
  type        = string
}

variable "log_shipping_oidc_fully_qualified_subjects" {
  description = "The list of trusted resources which can assume the 'log-shipping' role using OpenID Connect."
  default     = []
  type        = list(string)
}

variable "phlare_bucket_name" {
  default     = ""
  description = "The name of the S3 bucket that will be used by Phlare"
  type        = string
}

variable "phlare_oidc_fully_qualified_subjects" {
  description = "The list of trusted resources which can assume the 'phlare' role using OpenID Connect."
  default     = []
  type        = list(string)
}

variable "name" {
  description = "The name of the EKS cluster."
  type        = string
}

variable "region" {
  description = "The region in which to create the EKS cluster."
  type        = string
}

variable "self_managed_node_groups" {
  description = "A map describing the set of self-managed node groups to create. Other types of node groups besides self-managed are currently not supported."
  type = map(object({
    ami_type                 = string
    ami_name_filter          = string
    extra_tags               = map(string)
    instance_type            = string
    kubelet_extra_args       = string
    max_nodes                = number
    min_nodes                = number
    name                     = string
    pre_bootstrap_user_data  = string
    post_bootstrap_user_data = string
    cloudinit_pre_nodeadm = optional(list(object({
      content      = string
      content_type = optional(string)
      filename     = optional(string)
      merge_type   = optional(string)
    })))
    cloudinit_post_nodeadm = optional(list(object({
      content      = string
      content_type = optional(string)
      filename     = optional(string)
      merge_type   = optional(string)
    })))
    root_volume_id               = string
    root_volume_size             = number
    root_volume_type             = string
    subnet_ids                   = list(string)
    iam_role_additional_policies = map(string)
    iam_role_policy_arn          = optional(string)
    create_iam_instance_profile  = optional(bool)
    iam_instance_profile_arn     = optional(string)
    iam_role_arn                 = optional(string)
    key_name                     = optional(string)
    create_access_entry          = optional(bool, true)
    availability_zones           = optional(list(string))
    enable_efa_support           = optional(bool, false)
    network_interfaces           = optional(list(any))
    metadata_options = optional(object({
      http_endpoint               = optional(string, "enabled")
      http_protocol_ipv6          = optional(string)
      http_put_response_hop_limit = optional(number, 2)
      http_tokens                 = optional(string, "required")
      instance_metadata_tags      = optional(string)
    }))
  }))
}

variable "tags" {
  description = "The set of tags to place on the EKS cluster."
  type        = map(string)
}

variable "velero_bucket_name" {
  default     = ""
  description = "The name of the S3 bucket that will be used to upload Velero backups."
  type        = string
}

variable "velero_oidc_fully_qualified_subjects" {
  description = "The list of trusted resources which can assume the 'velero' role using OpenID Connect."
  default     = []
  type        = list(string)
}

variable "vpc_id" {
  description = "The ID of the VPC in which to create the EKS cluster."
  type        = string
}

variable "worker_node_additional_policies" {
  default     = []
  description = "A list of additional policies to add to worker nodes."
  type        = list(string)
}

variable "create_iam_role" {
  description = "Whether to create an IAM role for the EKS cluster. If set to false, the 'eks_cluster_role_arn' variable must be provided."
  default     = true
  type        = bool
}

variable "iam_role_arn" {
  description = "The ARN of the IAM role to use for the EKS cluster. If not provided, a new IAM role will be created."
  default     = null
  type        = string
}

variable "create_node_iam_role" {
  description = "Whether to create an IAM role for the EKS worker nodes. If set to false, the 'node_iam_role_arn' variable must be provided."
  default     = true
  type        = bool
}

variable "external_source_cidrs" {
  description = "A list of CIDRs that should be allowed to access the EKS cluster API server."
  default     = [""]
  type        = list(string)

}