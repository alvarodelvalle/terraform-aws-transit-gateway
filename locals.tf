locals {
  module_name = "terraform-aws-transit-gateway"
  lb_targets = flatten([
    for lb_key, lb in var.elbs : [
      for t_key, t in lb.targets : {
        lb_key             = lb_key
        target_key         = t_key
        target_type        = t.type
        targets            = t.targets
        target_hc_path     = t.health_check_path
        target_hc_port     = t.health_check_port
        target_hc_protocol = t.health_check_protocol
        vpc_name           = lb.vpc_name
      }
    ]
  ])
  lb_listeners = flatten([
    for lb_key, lb in var.elbs : [
      for listener_key, listeners in lb.listeners : {
        lb_key       = lb_key
        port         = listeners.port
        protocol     = listeners.protocol
        target_group = listeners.target_group
        vpc_name     = lb.vpc_name
      }
    ]
  ])
  tgw_routes = flatten([
    for rt_key, rt in var.tgw_route_tables : [
      for k, v in rt.routes : {
        tgw_name        = rt.transit_gateway_name
        tgw_route_table = rt_key
        cidr            = k
        type            = v.type
        tgw_attachment  = v.attachment
      }
    ]
  ])
  tgw_rtb_associations = flatten([
    for rt_key, rt in var.tgw_route_tables : [
      for x in rt.associations : {
        tgw_name        = rt.transit_gateway_name
        tgw_route_table = rt_key
        tgw_attachment  = x
      }
    ]
  ])
  tgw_rtb_propagations = flatten([
    for rt_key, rt in var.tgw_route_tables : [
      for x in rt.route_propagations : {
        tgw_name        = rt.transit_gateway_name
        tgw_route_table = rt_key
        tgw_attachment  = x
      }
    ]
  ])
}
