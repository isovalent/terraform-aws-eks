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

// Used to get the ID of the current AWS account.
data "aws_caller_identity" "current" {}

// Creates an IAM policy used for log shipping.
resource "aws_iam_policy" "log_shipping" {
  count       = length(var.log_shipping_oidc_fully_qualified_subjects) > 0 ? 1 : 0
  description = "IAM policy for log shipping for cluster '${var.name}'."
  name_prefix = "eks-${local.log_shipping_role_name}"
  path        = local.iam_path
  policy      = data.aws_iam_policy_document.log_shipping[0].json
  tags        = var.tags
}

// Used to create the actual IAM policy based on a bunch of variable parameters.
data "aws_iam_policy_document" "log_shipping" {
  count = length(var.log_shipping_oidc_fully_qualified_subjects) > 0 ? 1 : 0

  statement {
    effect = "Allow"
    sid    = "Sid0"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = [
      join("/", [aws_s3_bucket.log_shipping[0].arn, "*"])
    ]
  }

  statement {
    effect = "Allow"
    sid    = "Sid1"

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.log_shipping[0].arn,
    ]
  }

  statement {
    effect = "Allow"
    sid    = "Sid2"

    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.log_shipping_role_name}",
    ]
  }
}

// Enables a set of Kubernetes service accounts ("fully qualified subjects") to assume the 'log-shipping' IAM role.
module "iam_assumable_role_log_shipping" {
  count   = length(var.log_shipping_oidc_fully_qualified_subjects) > 0 ? 1 : 0
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.4.0"

  create_role                   = true
  provider_url                  = replace(module.main.cluster_oidc_issuer_url, "https://", "")
  oidc_fully_qualified_subjects = var.log_shipping_oidc_fully_qualified_subjects
  role_name                     = local.log_shipping_role_name
  role_policy_arns = [
    aws_iam_policy.log_shipping[0].arn,
  ]
}

// Creates an IAM policy used for log shipping used for the AWS Load Balancer controller.
resource "aws_iam_policy" "aws_load_balancer_controller" {
  count       = length(var.aws_load_balancer_controller_oidc_fully_qualified_subjects) > 0 ? 1 : 0
  description = "IAM policy for AWS Load Balancer Controller for cluster '${var.name}'."
  name_prefix = "eks-${local.aws_load_balancer_controller_role_name}"
  path        = local.iam_path
  policy      = file(join("/", [path.module, "policies", "aws-load-balancer-controller.json"]))
  tags        = var.tags
}

// Enables a set of Kubernetes service accounts ("fully qualified subjects") to assume the 'aws-load-balancer-controller' IAM role.
module "iam_assumable_role_aws_load_balancer_controller" {
  count   = length(var.aws_load_balancer_controller_oidc_fully_qualified_subjects) > 0 ? 1 : 0
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.4.0"

  create_role                   = true
  provider_url                  = replace(module.main.cluster_oidc_issuer_url, "https://", "")
  oidc_fully_qualified_subjects = var.aws_load_balancer_controller_oidc_fully_qualified_subjects
  role_name                     = local.aws_load_balancer_controller_role_name
  role_policy_arns = [
    aws_iam_policy.aws_load_balancer_controller[0].arn,
  ]
}

// Creates an IAM policy used for the AWS EBS CSI driver.
resource "aws_iam_policy" "aws_ebs_csi_driver" {
  count       = length(var.aws_ebs_csi_driver_oidc_fully_qualified_subjects) > 0 ? 1 : 0
  description = "IAM policy for AWS EBS CSI Driver for cluster '${var.name}'."
  name_prefix = "eks-${local.aws_ebs_csi_driver_role_name}"
  path        = local.iam_path
  policy      = file(join("/", [path.module, "policies", "aws-ebs-csi-driver.json"]))
  tags        = var.tags
}

// Enables a set of Kubernetes service accounts ("fully qualified subjects") to assume the 'aws-ebs-csi-driver' IAM role.
module "iam_assumable_role_aws_ebs_csi_driver" {
  count   = length(var.aws_ebs_csi_driver_oidc_fully_qualified_subjects) > 0 ? 1 : 0
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.4.0"

  create_role                   = true
  provider_url                  = replace(module.main.cluster_oidc_issuer_url, "https://", "")
  oidc_fully_qualified_subjects = var.aws_ebs_csi_driver_oidc_fully_qualified_subjects
  role_name                     = local.aws_ebs_csi_driver_role_name
  role_policy_arns = [
    aws_iam_policy.aws_ebs_csi_driver[0].arn,
  ]
}

// Creates an IAM policy for the cluster autoscaler.
resource "aws_iam_policy" "cluster_autoscaler" {
  count       = length(var.cluster_autoscaler_oidc_fully_qualified_subjects) > 0 ? 1 : 0
  description = "IAM policy for 'cluster-autoscaler' policy for cluster '${module.main.cluster_name}'"
  name_prefix = "eks-${local.cluster_autoscaler_role_name}"
  path        = local.iam_path
  policy      = file(join("/", [path.module, "policies", "cluster-autoscaler.json"]))
  tags        = var.tags
}

// Enables a set of Kubernetes service accounts ("fully qualified subjects") to assume the 'cluster-autoscaler' IAM role.
module "iam_assumable_role_cluster_autoscaler" {
  count   = length(var.cluster_autoscaler_oidc_fully_qualified_subjects) > 0 ? 1 : 0
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.4.0"

  create_role                   = true
  provider_url                  = replace(module.main.cluster_oidc_issuer_url, "https://", "")
  oidc_fully_qualified_subjects = var.cluster_autoscaler_oidc_fully_qualified_subjects
  role_name                     = local.cluster_autoscaler_role_name
  role_policy_arns = [
    aws_iam_policy.cluster_autoscaler[0].arn,
  ]
}

// Creates an IAM policy for 'external-dns'.
resource "aws_iam_policy" "external_dns" {
  count       = length(var.external_dns_oidc_fully_qualified_subjects) > 0 ? 1 : 0
  description = "IAM policy for 'external-dns' for cluster '${var.name}'."
  name_prefix = "eks-${local.external_dns_role_name}"
  path        = local.iam_path
  policy      = file(join("/", [path.module, "policies", "external-dns.json"]))
  tags        = var.tags
}

// Enables a set of Kubernetes service accounts ("fully qualified subjects") to assume the 'external-dns' IAM role.
module "iam_assumable_role_external_dns" {
  count   = length(var.external_dns_oidc_fully_qualified_subjects) > 0 ? 1 : 0
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.4.0"

  create_role                   = true
  provider_url                  = replace(module.main.cluster_oidc_issuer_url, "https://", "")
  oidc_fully_qualified_subjects = var.external_dns_oidc_fully_qualified_subjects
  role_name                     = local.external_dns_role_name
  role_policy_arns = [
    aws_iam_policy.external_dns[0].arn,
  ]
}

// Creates an IAM policy for 'cert-manager'.
resource "aws_iam_policy" "cert_manager" {
  count       = length(var.cert_manager_oidc_fully_qualified_subjects) > 0 ? 1 : 0
  description = "IAM policy for 'cert-manager' for cluster '${var.name}'."
  name_prefix = "eks-${local.cert_manager_role_name}"
  path        = local.iam_path
  policy      = file(join("/", [path.module, "policies", "cert-manager.json"]))
  tags        = var.tags
}

// Enables a set of Kubernetes service accounts ("fully qualified subjects") to assume the 'cert-manager' IAM role.
module "iam_assumable_role_cert_manager" {
  count   = length(var.cert_manager_oidc_fully_qualified_subjects) > 0 ? 1 : 0
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.4.0"

  create_role                   = true
  provider_url                  = replace(module.main.cluster_oidc_issuer_url, "https://", "")
  oidc_fully_qualified_subjects = var.cert_manager_oidc_fully_qualified_subjects
  role_name                     = local.cert_manager_role_name
  role_policy_arns = [
    aws_iam_policy.cert_manager[0].arn,
  ]
}


// Creates an IAM policy used for Velero.
resource "aws_iam_policy" "velero" {
  count       = length(var.velero_oidc_fully_qualified_subjects) > 0 ? 1 : 0
  description = "IAM policy for Velero for cluster '${var.name}'."
  name_prefix = "eks-${local.velero_role_name}"
  path        = local.iam_path
  policy      = data.aws_iam_policy_document.velero[0].json
  tags        = var.tags
}

// Used to create the actual IAM policy based on a bunch of variable parameters.
data "aws_iam_policy_document" "velero" {
  count = length(var.velero_oidc_fully_qualified_subjects) > 0 ? 1 : 0

  statement {
    effect = "Allow"
    sid    = "Sid0"

    actions = [
      "ec2:DescribeVolumes",
      "ec2:DescribeSnapshots",
      "ec2:CreateTags",
      "ec2:CreateVolume",
      "ec2:CreateSnapshot",
      "ec2:DeleteSnapshot"
    ]

    resources = [
      "*",
    ]
  }

  statement {
    effect = "Allow"
    sid    = "Sid1"

    actions = [
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:PutObject",
      "s3:AbortMultipartUpload",
      "s3:ListMultipartUploadParts"
    ]

    resources = [
      join("/", [aws_s3_bucket.velero[0].arn, "*"])
    ]
  }

  statement {
    effect = "Allow"
    sid    = "Sid2"

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.velero[0].arn,
    ]
  }
}

// Enables a set of Kubernetes service accounts ("fully qualified subjects") to assume the 'velero' IAM role.
module "iam_assumable_role_velero" {
  count   = length(var.velero_oidc_fully_qualified_subjects) > 0 ? 1 : 0
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.9.2"

  create_role                   = true
  provider_url                  = replace(module.main.cluster_oidc_issuer_url, "https://", "")
  oidc_fully_qualified_subjects = var.velero_oidc_fully_qualified_subjects
  role_name                     = local.velero_role_name
  role_policy_arns = [
    aws_iam_policy.velero[0].arn,
  ]
}
