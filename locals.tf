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

locals {
  aws_ebs_csi_driver_role_name           = "aws-ebs-csi-driver-${var.name}"                 // The name of the IAM role to be used by the AWS EBS CSI driver.
  aws_load_balancer_controller_role_name = "aws-load-balancer-controller-${var.name}"       // The name of the IAM role to be used by the AWS Load Balancer controller.
  cert_manager_role_name                 = "cert-manager-${var.name}"                       // The name of the IAM role to be used by 'cert-manager'.
  cluster_autoscaler_role_name           = "cluster-autoscaler-${var.name}"                 // The name of the IAM role to be used by 'cluster-autoscaler'.
  external_dns_role_name                 = "external-dns-${var.name}"                       // The name of the IAM role to be used by 'external-dns'.
  iam_path                               = "/"                                              // The path in which to create IAM resources.
  log_shipping_role_name                 = "log-shipping-${var.name}"                       // The name of the IAM role to be used by any log-shipping component(s).
  path_to_kubeconfig_file                = abspath("${path.module}/${var.name}.kubeconfig") // The path to the kubeconfig file that will be created and output.
  velero_role_name                       = "velero-${var.name}"                             // The name of the IAM role to be used by Velero.
}
