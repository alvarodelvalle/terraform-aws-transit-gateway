resource "aws_vpc" "this" {
  for_each                         = var.vpcs
  cidr_block                       = lookup(each.value, "cidr_block", "10.0.0.0/16")
  instance_tenancy                 = lookup(each.value, "instance_tenancy", null)
  enable_dns_support               = each.value.enable_dns_support
  enable_dns_hostnames             = each.value.enable_dns_hostnames
  enable_classiclink               = each.value.enable_classiclink
  enable_classiclink_dns_support   = each.value.enable_classiclink_dns_support
  assign_generated_ipv6_cidr_block = each.value.assign_generated_ipv6_cidr_block
  tags = merge(
    each.value.tags,
    var.tags
  )
}

resource "aws_internet_gateway" "this" {
  for_each = var.vpcs
  vpc_id   = aws_vpc.this[each.key].id
  tags = merge(
    var.tags,
    each.value.igw_tags,
  )
}

resource "aws_subnet" "private" {
  for_each                = var.private_subnets
  vpc_id                  = aws_vpc.this[each.value.vpc_name].id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.map_public_ip_on_launch
  tags = merge(
    {
      "Name" = each.key
      "Tier" = "Private"
    },
    var.tags,
    each.value.tags
  )
}

resource "aws_subnet" "public" {
  for_each                = var.public_subnets
  vpc_id                  = aws_vpc.this[each.value.vpc_name].id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.map_public_ip_on_launch
  tags = merge(
    {
      "Name" = each.key
      "Tier" = "Public"
    },
    var.tags,
    each.value.tags
  )
}

resource "aws_route_table" "this" {
  for_each = var.vpc_route_tables
  vpc_id   = aws_vpc.this[each.value.vpc_name].id
  tags = merge(
    {
      "Name" = each.key
    },
    var.tags
  )
  dynamic "route" {
    for_each = each.value.routes
    content {
      cidr_block         = route.value["route_cidr_destination"]
      transit_gateway_id = lookup(route.value, "transit_gateway_name", null) != null ? aws_ec2_transit_gateway.this[route.value["transit_gateway_name"]].id : null
      // IGW
      gateway_id      = lookup(route.value, "gateway_name", null) != null ? data.aws_internet_gateway.this[each.value["vpc_name"]].id : null
      vpc_endpoint_id = lookup(route.value, "vpc_endpoint_name", null) != null ? aws_vpc_endpoint.this[route.value["vpc_endpoint_name"]].id : null
    }
  }
}

resource "aws_route_table_association" "subnets" {
  for_each       = var.route_table_subnet_associations
  route_table_id = aws_route_table.this[each.key].id
  subnet_id      = data.aws_subnets.this[each.value.route_subnet_association].ids[0]
  depends_on     = [aws_subnet.public, aws_subnet.private]
}

resource "aws_vpc_endpoint" "this" {
  for_each     = var.vpc_endpoints
  auto_accept  = true
  service_name = aws_vpc_endpoint_service.this[each.value].service_name
  vpc_id       = aws_vpc.this[each.value.vpc_name].id
}

#TODO - Create the service endpoints
resource "aws_vpc_endpoint_service" "this" {
  acceptance_required = false
  private_dns_name = ""
}

resource "aws_vpc_endpoint_subnet_association" "this" {
  for_each        = var.vpc_endpoints
  subnet_id       = data.aws_subnets.this[each.value.endpoint_subnet].ids[0]
  vpc_endpoint_id = aws_vpc_endpoint.this[each.key].id
  depends_on      = [aws_subnet.private, aws_subnet.public]
}

resource "aws_vpc_endpoint_service" "this" {
  for_each                   = { for k, v in var.vpc_endpoint_service : k => v if v.type == "gateway" }
  acceptance_required        = false
  gateway_load_balancer_arns = [aws_lb.this[each.value.target].arn]
}

resource "aws_security_group" "this" {
  for_each               = var.security_groups
  name                   = each.key
  vpc_id                 = aws_vpc.this[each.value.vpc_name].id
  revoke_rules_on_delete = true
  dynamic "ingress" {
    for_each = { for k, v in each.value.rules : k => v if v.type == "ingress" }
    content {
      description     = lookup(ingress.value, "description", "")
      protocol        = lookup(ingress.value, "protocol", "-1")
      from_port       = lookup(ingress.value, "from_port", 0)
      to_port         = lookup(ingress.value, "to_port", 0)
      cidr_blocks     = lookup(ingress.value, "cidrs", null)
      prefix_list_ids = lookup(ingress.value, "prefix_list_ids", null)
      security_groups = lookup(ingress.value, "security_groups", null)
      self            = lookup(ingress.value, "self", false)
    }
  }
  dynamic "egress" {
    for_each = { for k, v in each.value.rules : k => v if v.type == "egress" }
    content {
      description     = lookup(egress.value, "description", "")
      protocol        = lookup(egress.value, "protocol", "-1")
      from_port       = lookup(egress.value, "from_port", 0)
      to_port         = lookup(egress.value, "to_port", 0)
      cidr_blocks     = lookup(egress.value, "cidrs", "0.0.0.0/0")
      prefix_list_ids = lookup(egress.value, "prefix_list_ids", null)
      security_groups = lookup(egress.value, "security_groups", null)
      self            = lookup(egress.value, "self", false)
    }
  }
  tags = merge(
    {
      "Name" = each.key
    },
    var.tags,
    each.value.tags
  )
}
