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

output "aws_ebs_csi_driver_role_arn" {
  value = length(var.aws_ebs_csi_driver_oidc_fully_qualified_subjects) > 0 ? module.iam_assumable_role_aws_ebs_csi_driver[0].iam_role_arn : ""
}

output "aws_ebs_csi_driver_policy_arn" {
  value = length(var.aws_ebs_csi_driver_oidc_fully_qualified_subjects) > 0 ? aws_iam_policy.aws_ebs_csi_driver[0].arn : ""
}

output "aws_load_balancer_controller_role_arn" {
  value = length(var.aws_load_balancer_controller_oidc_fully_qualified_subjects) > 0 ? module.iam_assumable_role_aws_load_balancer_controller[0].iam_role_arn : ""
}

output "cert_manager_role_arn" {
  value = length(var.cert_manager_oidc_fully_qualified_subjects) > 0 ? module.iam_assumable_role_cert_manager[0].iam_role_arn : ""
}

output "cluster_autoscaler_role_arn" {
  value = length(var.cluster_autoscaler_oidc_fully_qualified_subjects) > 0 ? module.iam_assumable_role_cluster_autoscaler[0].iam_role_arn : ""
}

output "external_dns_role_arn" {
  value = length(var.external_dns_oidc_fully_qualified_subjects) > 0 ? module.iam_assumable_role_external_dns[0].iam_role_arn : ""
}

output "id" {
  value = module.main.cluster_name
}

output "log_shipping_bucket_name" {
  value = length(var.log_shipping_oidc_fully_qualified_subjects) > 0 ? aws_s3_bucket.log_shipping[0].id : ""
}

output "log_shipping_role_arn" {
  value = length(var.log_shipping_oidc_fully_qualified_subjects) > 0 ? module.iam_assumable_role_log_shipping[0].iam_role_arn : ""
}

output "path_to_kubeconfig_file" {
  value = local.path_to_kubeconfig_file
}

output "workers_security_group_id" {
  value = module.main.node_security_group_id
}

output "workers_iam_role_arns" {
  value = toset([
    for k, v in module.main.self_managed_node_groups : v.iam_role_arn
  ])
}

output "ssh_key_name" {
  value = aws_key_pair.ssh_access.key_name
}

output "ssh_private_key_pem" {
  sensitive = true
  value     = tls_private_key.ssh_key.private_key_pem
}

output "oidc_provider_arn" {
  value = module.main.oidc_provider_arn
}

output "cluster_version" {
  value = module.main.cluster_version
}

output "cluster_arn" {
  value = module.main.cluster_arn
}

output "cluster_endpoint" {
  value = module.main.cluster_endpoint
}


output "oidc_provider_url" {
  value = module.main.oidc_provider
}


output "cluster_certificate_authority_data" {
  value = module.main.cluster_certificate_authority_data
}

output "cluster_autoscaler_names" {
  value = module.main.self_managed_node_groups_autoscaling_group_names
}
