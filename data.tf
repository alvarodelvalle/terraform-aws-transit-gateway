data "aws_route_table" "this" {
  for_each = var.vpc_route_tables
  filter {
    name   = "tag:Name"
    values = [each.key]
  }
  depends_on = [aws_route_table.this]
}

data "aws_ec2_transit_gateway" "this" {
  for_each = var.tgws
  filter {
    name   = "tag:Name"
    values = [each.key]
  }
  filter {
    name   = "state"
    values = ["available"]
  }

  depends_on = [aws_ec2_transit_gateway.this]
}

data "aws_subnets" "this" {
  for_each = merge(var.public_subnets, var.private_subnets)
  filter {
    name   = "tag:Name"
    values = [each.key]
  }
  depends_on = [aws_subnet.public, aws_subnet.private]
}

data "aws_internet_gateway" "this" {
  for_each = var.vpcs
  filter {
    name   = "tag:Name"
    values = [for x in each.value["igw_tags"] : x]
  }
  depends_on = [aws_vpc.this, aws_internet_gateway.this]
}
