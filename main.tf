resource "aws_ec2_transit_gateway" "this" {
  for_each                        = var.tgws
  description                     = coalesce(each.value.description, each.key)
  amazon_side_asn                 = lookup(each.value, "amazon_side_asn", null)
  default_route_table_association = lookup(each.value, "default_route_table_association", "disable")
  default_route_table_propagation = lookup(each.value, "default_route_table_propagation", "disable")
  auto_accept_shared_attachments  = lookup(each.value, "auto_accept_shared_attachments", "disable")
  dns_support                     = lookup(each.value, "dns_support", "enable")
  vpn_ecmp_support                = lookup(each.value, "vpn_ecmp_support", "enable")
  tags = merge(
    {
      "Name" = each.key
    },
    var.tags,
    each.value["tags"]
  )
}

resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  for_each                                        = var.tgw_vpc_attachments
  transit_gateway_id                              = aws_ec2_transit_gateway.this[each.value.tgw_name].id
  vpc_id                                          = aws_vpc.this[each.value.vpc_name].id
  subnet_ids                                      = [for x in each.value.subnets : data.aws_subnets.this[x].ids[0]]
  dns_support                                     = lookup(each.value, "dns_support", true) ? "enable" : "disable"
  ipv6_support                                    = lookup(each.value, "ipv6_support", false) ? "enable" : "disable"
  appliance_mode_support                          = lookup(each.value, "appliance_mode_support", true) ? "enable" : "disable"
  transit_gateway_default_route_table_association = lookup(each.value, "transit_gateway_default_route_table_association", false)
  transit_gateway_default_route_table_propagation = lookup(each.value, "transit_gateway_default_route_table_propagation", false)
  tags = merge(
    {
      Name = join("-", compact([var.name, each.key]))
    },
    var.tags,
    var.tgw_vpc_attachment_tags,
  )
  depends_on = [aws_subnet.private, aws_subnet.public]
}

resource "aws_ec2_transit_gateway_route_table" "this" {
  for_each           = var.tgw_route_tables
  transit_gateway_id = aws_ec2_transit_gateway.this[each.value["transit_gateway_name"]].id
  tags = merge(
    {
      "Name" = each.key
    },
    var.tags,
    lookup(each.value, "tgw_route_table_tags", null),
  )
  depends_on = [aws_ec2_transit_gateway.this]
}

locals {
  tgw_routes = flatten([
    for k, v in var.tgw_route_tables : [
      for i, r in v.routes : {
        route                          = r
        transit_gateway_route_table_id = k
        vpc_association                = v.vpc_associations[i]
      }
    ] if length(v.routes) == length(v.vpc_associations)
  ])
}

resource "aws_ec2_transit_gateway_route" "this" {
  count = length(local.tgw_routes)

  destination_cidr_block = local.tgw_routes[count.index].route
  # blackhole                      = lookup(local.vpc_attachments_with_routes[count.index][1], "blackhole", null)
  transit_gateway_attachment_id  =aws_ec2_transit_gateway_vpc_attachment.this[local.tgw_routes[count.index].vpc_association].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this[local.tgw_routes[count.index].transit_gateway_route_table_id].id
}

# resource "aws_ec2_transit_gateway_route_table_association" "this" {
#   for_each = local.vpc_attachments_without_default_route_table_association
#   # Create association if it was not set already by aws_ec2_transit_gateway_vpc_attachment resource
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.this[each.key].id
#   transit_gateway_route_table_id = coalesce(lookup(each.value, "transit_gateway_route_table_id", null), var.transit_gateway_route_table_id, aws_ec2_transit_gateway_route_table.this[0].id)
# }

# resource "aws_ec2_transit_gateway_route_table_propagation" "this" {
#   for_each = local.vpc_attachments_without_default_route_table_propagation
#   # Create association if it was not set already by aws_ec2_transit_gateway_vpc_attachment resource
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.this[each.key].id
#   transit_gateway_route_table_id = coalesce(lookup(each.value, "transit_gateway_route_table_id", null), var.transit_gateway_route_table_id, aws_ec2_transit_gateway_route_table.this[0].id)
# }

# resource "aws_route" "tgw" {
#   for_each               = { for x in local.vpc_route_table_destination_cidr : x.rtb_id => x.cidr }
#   route_table_id         = each.key
#   destination_cidr_block = each.value
#   transit_gateway_id     = aws_ec2_transit_gateway.this[0].id
# }

# ###########################
# ## Resource Access Manager
# ###########################
# #resource "aws_ram_resource_share" "this" {
# #  count = var.create_tgw && var.share_tgw ? 1 : 0
# #
# #  name                      = coalesce(var.ram_name, var.name)
# #  allow_external_principals = var.ram_allow_external_principals
# #
# #  tags = merge(
# #    {
# #      "Name" = format("%s", coalesce(var.ram_name, var.name))
# #    },
# #    var.tags,
# #    var.ram_tags,
# #  )
# #}
# #
# #resource "aws_ram_resource_association" "this" {
# #  count = var.create_tgw && var.share_tgw ? 1 : 0
# #
# #  resource_arn       = aws_ec2_transit_gateway.this[0].arn
# #  resource_share_arn = aws_ram_resource_share.this[0].id
# #}
# #
# #resource "aws_ram_principal_association" "this" {
# #  count = var.create_tgw && var.share_tgw ? length(var.ram_principals) : 0
# #
# #  principal          = var.ram_principals[count.index]
# #  resource_share_arn = aws_ram_resource_share.this[0].arn
# #}
# #
# #resource "aws_ram_resource_share_accepter" "this" {
# #  count = !var.create_tgw && var.share_tgw ? 1 : 0
# #
# #  share_arn = var.ram_resource_share_arn
# #}
