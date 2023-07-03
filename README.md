# terraform-aws-eks

An opinionated Terraform module that can be used to create and manage an EKS cluster in AWS in a simplified way.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.31.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.1.1 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | < 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.31.0 |
| <a name="provider_null"></a> [null](#provider\_null) | >= 3.1.1 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | < 4.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_assumable_role_aws_ebs_csi_driver"></a> [iam\_assumable\_role\_aws\_ebs\_csi\_driver](#module\_iam\_assumable\_role\_aws\_ebs\_csi\_driver) | terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc | 5.4.0 |
| <a name="module_iam_assumable_role_aws_load_balancer_controller"></a> [iam\_assumable\_role\_aws\_load\_balancer\_controller](#module\_iam\_assumable\_role\_aws\_load\_balancer\_controller) | terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc | 5.4.0 |
| <a name="module_iam_assumable_role_cert_manager"></a> [iam\_assumable\_role\_cert\_manager](#module\_iam\_assumable\_role\_cert\_manager) | terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc | 5.4.0 |
| <a name="module_iam_assumable_role_cluster_autoscaler"></a> [iam\_assumable\_role\_cluster\_autoscaler](#module\_iam\_assumable\_role\_cluster\_autoscaler) | terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc | 5.4.0 |
| <a name="module_iam_assumable_role_external_dns"></a> [iam\_assumable\_role\_external\_dns](#module\_iam\_assumable\_role\_external\_dns) | terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc | 5.4.0 |
| <a name="module_iam_assumable_role_log_shipping"></a> [iam\_assumable\_role\_log\_shipping](#module\_iam\_assumable\_role\_log\_shipping) | terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc | 5.4.0 |
| <a name="module_iam_assumable_role_phlare"></a> [iam\_assumable\_role\_phlare](#module\_iam\_assumable\_role\_phlare) | terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc | 5.4.0 |
| <a name="module_iam_assumable_role_velero"></a> [iam\_assumable\_role\_velero](#module\_iam\_assumable\_role\_velero) | terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc | 5.9.2 |
| <a name="module_main"></a> [main](#module\_main) | terraform-aws-modules/eks/aws | 19.4.2 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.aws_ebs_csi_driver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.aws_load_balancer_controller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.cert_manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.external_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.log_shipping](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.phlare](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.velero](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_instance.echo-server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_key_pair.ssh_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_s3_bucket.log_shipping](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.phlare](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.velero](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.log_shipping](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_acl.phlare](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_acl.velero](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_lifecycle_configuration.velero](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_ownership_controls.log_shipping_ownership_controls](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_ownership_controls.phlare_ownership_controls](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_ownership_controls.velero_ownership_controls](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_public_access_block.log_shipping_block_public_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_public_access_block.phlare_block_public_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_public_access_block.velero_block_public_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_security_group_rule.cluster_to_workers_ingress_all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.workers_egress_dns_tcp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.workers_egress_dns_udp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.workers_egress_http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.workers_egress_ssh](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.workers_to_workers_egress_all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.workers_to_workers_ingress_all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [null_resource.disable_aws_vpc_cni_plugin](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.kubeconfig](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.update_aws_auth_configmap](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.wait_for_control_plane_subnets](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [tls_private_key.ssh_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_ami.workers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.log_shipping](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.phlare](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.velero](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_subnets.eks_control_plane](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_imdsv1"></a> [allow\_imdsv1](#input\_allow\_imdsv1) | Whether to allow IMDSv1 access (insecure). | `bool` | `false` | no |
| <a name="input_ami_owners"></a> [ami\_owners](#input\_ami\_owners) | The list of acceptable owners of AMIs to be used for worker nodes. | `list(string)` | <pre>[<br>  "099720109477",<br>  "679593333241",<br>  "amazon",<br>  "self"<br>]</pre> | no |
| <a name="input_aws_ebs_csi_driver_oidc_fully_qualified_subjects"></a> [aws\_ebs\_csi\_driver\_oidc\_fully\_qualified\_subjects](#input\_aws\_ebs\_csi\_driver\_oidc\_fully\_qualified\_subjects) | The list of trusted resources which can assume the 'aws-ebs-csi-driver' role using OpenID Connect. | `list(string)` | `[]` | no |
| <a name="input_aws_load_balancer_controller_oidc_fully_qualified_subjects"></a> [aws\_load\_balancer\_controller\_oidc\_fully\_qualified\_subjects](#input\_aws\_load\_balancer\_controller\_oidc\_fully\_qualified\_subjects) | The list of trusted resources which can assume the 'aws-load-balancer-controller' role using OpenID Connect. | `list(string)` | `[]` | no |
| <a name="input_cert_manager_oidc_fully_qualified_subjects"></a> [cert\_manager\_oidc\_fully\_qualified\_subjects](#input\_cert\_manager\_oidc\_fully\_qualified\_subjects) | The list of trusted resources which can assume the 'cert-manager' role using OpenID Connect. | `list(string)` | `[]` | no |
| <a name="input_cluster_autoscaler_oidc_fully_qualified_subjects"></a> [cluster\_autoscaler\_oidc\_fully\_qualified\_subjects](#input\_cluster\_autoscaler\_oidc\_fully\_qualified\_subjects) | The list of trusted resources which can assume the 'cluster-autoscaler' role using OpenID Connect. | `list(string)` | `[]` | no |
| <a name="input_control_plane_subnet_ids"></a> [control\_plane\_subnet\_ids](#input\_control\_plane\_subnet\_ids) | Can be used to override the list of subnet IDs to use for the EKS control-plane. If not defined, subnets tagged with 'eks-control-plane: true' will be used. | `list(string)` | `[]` | no |
| <a name="input_disable_aws_vpc_cni_plugin"></a> [disable\_aws\_vpc\_cni\_plugin](#input\_disable\_aws\_vpc\_cni\_plugin) | Whether to disable the AWS VPC CNI plugin. Unless running in chaining mode, this should usually be 'true'. | `bool` | n/a | yes |
| <a name="input_echo_server_instance_enabled"></a> [echo\_server\_instance\_enabled](#input\_echo\_server\_instance\_enabled) | Whether to create an EC2 instance outside the cluster that can act as 'echo-server'. | `bool` | `false` | no |
| <a name="input_echo_server_instance_user_data"></a> [echo\_server\_instance\_user\_data](#input\_echo\_server\_instance\_user\_data) | The user data script to use for the 'echo-server' instance. | `string` | `""` | no |
| <a name="input_external_dns_oidc_fully_qualified_subjects"></a> [external\_dns\_oidc\_fully\_qualified\_subjects](#input\_external\_dns\_oidc\_fully\_qualified\_subjects) | The list of trusted resources which can assume the 'external-dns' role using OpenID Connect. | `list(string)` | `[]` | no |
| <a name="input_include_public_subnets"></a> [include\_public\_subnets](#input\_include\_public\_subnets) | Whether to include public subnets in the list of subnets usable by the EKS cluster. | `bool` | `true` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | The version of Kubernetes/EKS to use. | `string` | n/a | yes |
| <a name="input_log_shipping_bucket_name"></a> [log\_shipping\_bucket\_name](#input\_log\_shipping\_bucket\_name) | The name of the S3 bucket that will be used to store logs. | `string` | `""` | no |
| <a name="input_log_shipping_oidc_fully_qualified_subjects"></a> [log\_shipping\_oidc\_fully\_qualified\_subjects](#input\_log\_shipping\_oidc\_fully\_qualified\_subjects) | The list of trusted resources which can assume the 'log-shipping' role using OpenID Connect. | `list(string)` | `[]` | no |
| <a name="input_manage_aws_auth_configmap"></a> [manage\_aws\_auth\_configmap](#input\_manage\_aws\_auth\_configmap) | Whether the upstream 'terraform-aws-eks' module should manage the 'kube-system/aws-auth' configmap. If using Flux, this should probably be 'false'. If not, this should probably be set to 'true'. | `bool` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the EKS cluster. | `string` | n/a | yes |
| <a name="input_phlare_bucket_name"></a> [phlare\_bucket\_name](#input\_phlare\_bucket\_name) | The name of the S3 bucket that will be used by Phlare | `string` | `""` | no |
| <a name="input_phlare_oidc_fully_qualified_subjects"></a> [phlare\_oidc\_fully\_qualified\_subjects](#input\_phlare\_oidc\_fully\_qualified\_subjects) | The list of trusted resources which can assume the 'phlare' role using OpenID Connect. | `list(string)` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | The region in which to create the EKS cluster. | `string` | n/a | yes |
| <a name="input_self_managed_node_groups"></a> [self\_managed\_node\_groups](#input\_self\_managed\_node\_groups) | A map describing the set of self-managed node groups to create. Other types of node groups besides self-managed are currently not supported. | <pre>map(object({<br>    ami_name_filter              = string<br>    extra_tags                   = map(string)<br>    instance_type                = string<br>    kubelet_extra_args           = string<br>    max_nodes                    = number<br>    min_nodes                    = number<br>    name                         = string<br>    pre_bootstrap_user_data      = string<br>    post_bootstrap_user_data     = string<br>    root_volume_id               = string<br>    root_volume_size             = number<br>    root_volume_type             = string<br>    subnet_ids                   = list(string)<br>    iam_role_additional_policies = map(string)<br>  }))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | The set of tags to place on the EKS cluster. | `map(string)` | n/a | yes |
| <a name="input_velero_bucket_name"></a> [velero\_bucket\_name](#input\_velero\_bucket\_name) | The name of the S3 bucket that will be used to upload Velero backups. | `string` | `""` | no |
| <a name="input_velero_oidc_fully_qualified_subjects"></a> [velero\_oidc\_fully\_qualified\_subjects](#input\_velero\_oidc\_fully\_qualified\_subjects) | The list of trusted resources which can assume the 'velero' role using OpenID Connect. | `list(string)` | `[]` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC in which to create the EKS cluster. | `string` | n/a | yes |
| <a name="input_worker_node_additional_policies"></a> [worker\_node\_additional\_policies](#input\_worker\_node\_additional\_policies) | A list of additional policies to add to worker nodes. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_ebs_csi_driver_role_arn"></a> [aws\_ebs\_csi\_driver\_role\_arn](#output\_aws\_ebs\_csi\_driver\_role\_arn) | n/a |
| <a name="output_aws_load_balancer_controller_role_arn"></a> [aws\_load\_balancer\_controller\_role\_arn](#output\_aws\_load\_balancer\_controller\_role\_arn) | n/a |
| <a name="output_cert_manager_role_arn"></a> [cert\_manager\_role\_arn](#output\_cert\_manager\_role\_arn) | n/a |
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | n/a |
| <a name="output_cluster_autoscaler_role_arn"></a> [cluster\_autoscaler\_role\_arn](#output\_cluster\_autoscaler\_role\_arn) | n/a |
| <a name="output_cluster_version"></a> [cluster\_version](#output\_cluster\_version) | n/a |
| <a name="output_external_dns_role_arn"></a> [external\_dns\_role\_arn](#output\_external\_dns\_role\_arn) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_log_shipping_bucket_name"></a> [log\_shipping\_bucket\_name](#output\_log\_shipping\_bucket\_name) | n/a |
| <a name="output_log_shipping_role_arn"></a> [log\_shipping\_role\_arn](#output\_log\_shipping\_role\_arn) | n/a |
| <a name="output_oidc_provider_arn"></a> [oidc\_provider\_arn](#output\_oidc\_provider\_arn) | n/a |
| <a name="output_path_to_kubeconfig_file"></a> [path\_to\_kubeconfig\_file](#output\_path\_to\_kubeconfig\_file) | n/a |
| <a name="output_ssh_key_name"></a> [ssh\_key\_name](#output\_ssh\_key\_name) | n/a |
| <a name="output_ssh_private_key_pem"></a> [ssh\_private\_key\_pem](#output\_ssh\_private\_key\_pem) | n/a |
| <a name="output_workers_iam_role_arns"></a> [workers\_iam\_role\_arns](#output\_workers\_iam\_role\_arns) | n/a |
| <a name="output_workers_security_group_id"></a> [workers\_security\_group\_id](#output\_workers\_security\_group\_id) | n/a |
<!-- END_TF_DOCS -->
