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

// Create a rule to the node security group that allows egress DNS traffic (TCP).
resource "aws_security_group_rule" "workers_egress_dns_tcp" {
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  description       = "Allow outbound DNS traffic."
  from_port         = 53
  protocol          = "tcp"
  security_group_id = module.main.node_security_group_id
  to_port           = 53
  type              = "egress"
}

// Create a rule to the node security group that allows egress DNS traffic (UDP).
resource "aws_security_group_rule" "workers_egress_dns_udp" {
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  description       = "Allow outbound DNS traffic."
  from_port         = 53
  protocol          = "udp"
  security_group_id = module.main.node_security_group_id
  to_port           = 53
  type              = "egress"
}

// Create a rule to the node security group that allows egress HTTP traffic.
resource "aws_security_group_rule" "workers_egress_http" {
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  description       = "Allow outbound HTTP traffic."
  from_port         = 80
  protocol          = "tcp"
  security_group_id = module.main.node_security_group_id
  to_port           = 80
  type              = "egress"
}

// Create a rule to the node security group that allows egress SSH traffic.
resource "aws_security_group_rule" "workers_egress_ssh" {
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  description       = "Allow outbound SSH traffic."
  from_port         = 22
  protocol          = "tcp"
  security_group_id = module.main.node_security_group_id
  to_port           = 22
  type              = "egress"
}

// Create a rule to the node security group that allows all egress traffic between the nodes.
resource "aws_security_group_rule" "workers_to_workers_egress_all" {
  description              = "Allow all traffic within the security group."
  from_port                = 0
  protocol                 = "all"
  security_group_id        = module.main.node_security_group_id
  source_security_group_id = module.main.node_security_group_id
  to_port                  = 65535
  type                     = "egress"
}

// Create a rule to the node security group that allows all ingress traffic between the nodes.
resource "aws_security_group_rule" "workers_to_workers_ingress_all" {
  description              = "Allow all traffic within the security group."
  from_port                = 0
  protocol                 = "all"
  security_group_id        = module.main.node_security_group_id
  source_security_group_id = module.main.node_security_group_id
  to_port                  = 65535
  type                     = "ingress"
}

// Create a rule to the node security group that allows all ingress traffic from the control plane to the nodes.
resource "aws_security_group_rule" "cluster_to_workers_ingress_all" {
  description              = "Allow all traffic from the control plane."
  from_port                = 0
  protocol                 = "all"
  security_group_id        = module.main.node_security_group_id
  source_security_group_id = module.main.cluster_primary_security_group_id
  to_port                  = 65535
  type                     = "ingress"
}
