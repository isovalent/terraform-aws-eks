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

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.34.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.1.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "< 4.0.0" // https://github.com/terraform-aws-modules/terraform-aws-eks/issues/2170#issuecomment-1191922960
    }
  }
  required_version = ">= 1.3.0"
}

provider "kubernetes" {
  host                   = module.main.cluster_endpoint
  cluster_ca_certificate = base64decode(module.main.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.main.cluster_name]
  }
}
