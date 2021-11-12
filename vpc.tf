locals {
  module_name = "terraform-aws-transit-gateway"
}

resource "aws_vpc" "vpc" {
  for_each                         = var.vpcs
  cidr_block                       = each.value["cidr_block"]
  instance_tenancy                 = each.value["instance_tenancy"]
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
  vpc_id   = aws_vpc.vpc[each.key].id

  tags = merge(
    var.tags,
    each.value["igw_tags"],
  )
}

resource "aws_subnet" "private" {
  for_each          = (var.vpcs)["private_subnets"]
  vpc_id            = aws_vpc.vpc[each.key].id
  cidr_block        = each.value[]
  availability_zone = each.value["availability_zone"]
  tags = merge(
    {
      "Name" = format("%s", each.key)
    },
    var.tags,
    each.value["tags"]
  )
}

resource "aws_subnet" "public" {
  for_each          = var.public_subnets
  vpc_id            = each.value["vpc_id"]
  cidr_block        = each.value["cidr_block"]
  availability_zone = each.value["availability_zone"]
  tags = merge(
    {
      "Name" = format("%s", each.key)
    },
    var.tags,
    each.value["tags"]
  )
}
