# terraform-aws-transit-gateway
Transit gateway module
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~>1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=3.60.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=3.60.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ec2_transit_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway) | resource |
| [aws_ec2_transit_gateway_route.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route) | resource |
| [aws_ec2_transit_gateway_route_table.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table) | resource |
| [aws_ec2_transit_gateway_route_table_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_association) | resource |
| [aws_ec2_transit_gateway_route_table_propagation.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_propagation) | resource |
| [aws_ec2_transit_gateway_vpc_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_eip.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_instance.pan](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_lb.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.ip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_network_interface.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface) | resource |
| [aws_route_table.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.gateways](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_vpc_endpoint.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint_service.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_service) | resource |
| [aws_ec2_transit_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_transit_gateway) | data source |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/internet_gateway) | data source |
| [aws_route_table.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_table) | data source |
| [aws_subnets.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_eips"></a> [eips](#input\_eips) | Elastic IP's and allocation | `any` | `{}` | no |
| <a name="input_elbs"></a> [elbs](#input\_elbs) | Elastic load balancers. | `any` | `{}` | no |
| <a name="input_instances"></a> [instances](#input\_instances) | EC2 instances with their network interfaces | `any` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | Name to be used on all the resources as identifier | `string` | `""` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | Private subnets defined as a map.  See default for an example | `any` | `{}` | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | Public subnets defined as a map. See default for an example | `any` | `{}` | no |
| <a name="input_rt_gateway_associations_list"></a> [rt\_gateway\_associations\_list](#input\_rt\_gateway\_associations\_list) | Route table to subnet association | `list(string)` | `[]` | no |
| <a name="input_rt_subnet_associations_list"></a> [rt\_subnet\_associations\_list](#input\_rt\_subnet\_associations\_list) | Route table to subnet association | `list(string)` | `[]` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | Security Groups and in/e/gress rules. Do not use 'sg' in the name. | `map` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `object({})` | <pre>{<br>  "CreatedBy": "MissionCloud",<br>  "Terraform": true,<br>  "Terraform::Module": "terraform-aws-transit-gateway"<br>}</pre> | no |
| <a name="input_tgw_route_tables"></a> [tgw\_route\_tables](#input\_tgw\_route\_tables) | Transit gateway route tables | `map` | `{}` | no |
| <a name="input_tgw_vpc_attachments"></a> [tgw\_vpc\_attachments](#input\_tgw\_vpc\_attachments) | Transit Gateways VPC attachments | `any` | `{}` | no |
| <a name="input_tgws"></a> [tgws](#input\_tgws) | Transit Gateways | `any` | `{}` | no |
| <a name="input_vpc_endpoint_service"></a> [vpc\_endpoint\_service](#input\_vpc\_endpoint\_service) | VPC endpoint services; include type and target. | `map` | `{}` | no |
| <a name="input_vpc_endpoints"></a> [vpc\_endpoints](#input\_vpc\_endpoints) | VPC endpoints mapping | `any` | `{}` | no |
| <a name="input_vpc_route_tables"></a> [vpc\_route\_tables](#input\_vpc\_route\_tables) | VPC Route Tables | `any` | `{}` | no |
| <a name="input_vpcs"></a> [vpcs](#input\_vpcs) | VPC's defined as a map | `any` | `{}` | no |

## Outputs

No outputs.

# License

GNU General Public License v3.0 or later

See [COPYING](./COPYING) to see the full text.
