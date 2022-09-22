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

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "aws_key_pair" "ssh_access" {
  key_name   = "Generated SSH key for ${var.name}"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "echo-server" {
  count = var.echo_server_instance_enabled ? 1 : 0

  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  subnet_id = sort(data.aws_subnets.public.ids)[0]

  vpc_security_group_ids = [
    module.main.node_security_group_id,
  ]

  key_name = aws_key_pair.ssh_access.key_name

  user_data = var.echo_server_instance_user_data

  lifecycle {
    ignore_changes = [ami]
  }

  tags = merge(var.tags, {
    Name = "${var.name}-egressgw-echo-server"
  })
}
