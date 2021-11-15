locals {
  module_name = "terraform-aws-transit-gateway"
}

resource "aws_vpc" "this" {
  for_each                         = var.vpcs
  cidr_block                       = lookup(each.value, "cidr_block", "10.0.0.0/16")
  instance_tenancy                 = lookup(each.value, "instance_tenancy", null)
  enable_dns_support               = each.value["enable_dns_support"]
  enable_dns_hostnames             = each.value["enable_dns_hostnames"]
  enable_classiclink               = each.value["enable_classiclink"]
  enable_classiclink_dns_support   = each.value["enable_classiclink_dns_support"]
  assign_generated_ipv6_cidr_block = each.value["assign_generated_ipv6_cidr_block"]
  tags = merge(
    each.value["tags"],
    var.tags
  )
}

resource "aws_internet_gateway" "this" {
  for_each = var.vpcs
  vpc_id   = aws_vpc.this[each.key].id
  tags = merge(
    var.tags,
    each.value["igw_tags"],
  )
}

resource "aws_subnet" "private" {
  for_each                = var.private_subnets
  vpc_id                  = data.aws_vpc.this[each.value["vpc_name"]].id
  cidr_block              = each.value["cidr_block"]
  availability_zone       = each.value["availability_zone"]
  map_public_ip_on_launch = each.value["map_public_ip_on_launch"]
  tags = merge(
    {
      "Name" = each.key
      "Tier" = "Private"
    },
    var.tags,
    each.value["tags"]
  )
}

resource "aws_subnet" "public" {
  for_each                = var.public_subnets
  vpc_id                  = data.aws_vpc.this[each.value["vpc_name"]].id
  cidr_block              = each.value["cidr_block"]
  availability_zone       = each.value["availability_zone"]
  map_public_ip_on_launch = each.value["map_public_ip_on_launch"]
  tags = merge(
    {
      "Name" = each.key
      "Tier" = "Public"
    },
    var.tags,
    each.value["tags"]
  )
}

resource "aws_route_table" "this" {
  for_each = var.vpc_route_tables
  vpc_id   = aws_vpc.this[each.value["vpc_name"]].id
  tags = merge(
    {
      "Name" = each.key
    },
    var.tags
  )
  dynamic "route" {
    for_each = each.value["routes"]
    content {
      cidr_block         = route.value["route_cidr_destination"]
      transit_gateway_id = lookup(route.value, "transit_gateway_name", null) != null ?
        aws_ec2_transit_gateway.this[route.value["transit_gateway_name"]].id : null
      // IGW
      gateway_id = lookup(route.value, "gateway_name", null) != null ?
        data.aws_internet_gateway.this[each.value["vpc_name"]].id : null
      vpc_endpoint_id = lookup(route.value, "vpc_endpoint_name", null) != null ?
        aws_vpc_endpoint.this[route.value["vpc_endpoint_name"]].id : null
    }
  }
}

resource "aws_route_table_association" "subnets" {
  for_each       = var.route_table_subnet_associations
  route_table_id = aws_route_table.this[each.key]
  subnet_id      = data.aws_subnets.this[each.value["route_subnet_association"]].ids[0]
  depends_on     = [aws_subnet.public, aws_subnet.private]
}

resource "aws_vpc_endpoint" "this" {
  for_each = var.vpc_endpoints
  auto_accept = true
  service_name = lookup(each.value, "endpoint_service_name", null)
  vpc_id       = aws_vpc.this[each.value["vpc_name"]].id
}

resource "aws_vpc_endpoint_subnet_association" "this" {
  for_each = var.vpc_endpoints
  subnet_id       = data.aws_subnets.this[each.value["endpoint_subnet"]].ids[0]
  vpc_endpoint_id = aws_vpc_endpoint.this[each.key].id
}
