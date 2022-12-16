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

// Configure the S3 bucket used for log shipping.
resource "aws_s3_bucket" "log_shipping" {
  bucket = var.log_shipping_bucket_name                                                                             // The name of the bucket.
  count  = length(var.log_shipping_oidc_fully_qualified_subjects) > 0 && var.log_shipping_bucket_name != "" ? 1 : 0 // Only actually create the bucket if a service account used for log shipping and a bucket name have been specified.
  tags   = var.tags                                                                                                 // The set of tags to be placed on the bucket.
}

// Make the bucket and its contents private.
resource "aws_s3_bucket_acl" "log_shipping" {
  acl    = "private"
  bucket = aws_s3_bucket.log_shipping[0].id
  count  = length(var.log_shipping_oidc_fully_qualified_subjects) > 0 ? 1 : 0 // Only actually create the ACL if a service account used for log shipping has been specified.
}

// Blocks public access to the S3 bucket used for log shipping and to its contents.
resource "aws_s3_bucket_public_access_block" "log_shipping_block_public_access" {
  block_public_acls       = true
  block_public_policy     = true
  bucket                  = aws_s3_bucket.log_shipping[0].id
  count                   = length(var.log_shipping_oidc_fully_qualified_subjects) > 0 ? 1 : 0
  ignore_public_acls      = true
  restrict_public_buckets = true
}

// Configure the S3 bucket used for log shipping.
resource "aws_s3_bucket" "phlare" {
  bucket = var.phlare_bucket_name                                                                             // The name of the bucket.
  count  = length(var.phlare_oidc_fully_qualified_subjects) > 0 && var.phlare_bucket_name != "" ? 1 : 0 // Only actually create the bucket if a service account used for log shipping and a bucket name have been specified.
  tags   = var.tags                                                                                                 // The set of tags to be placed on the bucket.
}

// Make the bucket and its contents private.
resource "aws_s3_bucket_acl" "phlare" {
  acl    = "private"
  bucket = aws_s3_bucket.phlare[0].id
  count  = length(var.phlare_oidc_fully_qualified_subjects) > 0 ? 1 : 0 // Only actually create the ACL if a service account used for log shipping has been specified.
}

// Blocks public access to the S3 bucket used for log shipping and to its contents.
resource "aws_s3_bucket_public_access_block" "phlare_block_public_access" {
  block_public_acls       = true
  block_public_policy     = true
  bucket                  = aws_s3_bucket.phlare[0].id
  count                   = length(var.phlare_oidc_fully_qualified_subjects) > 0 ? 1 : 0
  ignore_public_acls      = true
  restrict_public_buckets = true
}

// Configure the S3 bucket used for Velero.
resource "aws_s3_bucket" "velero" {
  bucket = var.velero_bucket_name                                                                       // The name of the bucket.
  count  = length(var.velero_oidc_fully_qualified_subjects) > 0 && var.velero_bucket_name != "" ? 1 : 0 // Only actually create the bucket if a service account and a bucket name used for Velero have been specified.
  tags   = var.tags                                                                                     // The set of tags to be placed on the bucket.
}

resource "aws_s3_bucket_lifecycle_configuration" "velero" {
  bucket = aws_s3_bucket.velero[0].id
  count  = length(var.velero_oidc_fully_qualified_subjects) > 0 ? 1 : 0 // Only actually create the lifecycle rule if a service account used for Velero has been specified.

  // Establish a lifecycle rule that moves backups to different storage tiers based on their age and expires them after 90 days.
  rule {
    id     = "backup"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }

    expiration {
      days = 90
    }
  }
}

// Make the bucket and its contents private.
resource "aws_s3_bucket_acl" "velero" {
  acl    = "private"
  bucket = aws_s3_bucket.velero[0].id
  count  = length(var.velero_oidc_fully_qualified_subjects) > 0 ? 1 : 0 // Only actually create the ACL if a service account used for Velero has been specified.
}

// Blocks public access to the S3 bucket used for Velero and to its contents.
resource "aws_s3_bucket_public_access_block" "velero_block_public_access" {
  block_public_acls       = true
  block_public_policy     = true
  bucket                  = aws_s3_bucket.velero[0].id
  count                   = length(var.velero_oidc_fully_qualified_subjects) > 0 ? 1 : 0
  ignore_public_acls      = true
  restrict_public_buckets = true
}
