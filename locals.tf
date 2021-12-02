locals {
  module_name = "terraform-aws-transit-gateway"
  lb_targets = flatten([
    for lb_key, lb in var.elbs : [
      for t_key, t in lb.targets : {
        lb_key      = lb_key
        target_key  = t_key
        target_type = t.type
        targets     = t.targets
        target_hc_path = t.health_check_path
        target_hc_port = t.health_check_port
        target_hc_protocol = t.health_check_protocol
        vpc_name    = lb.vpc_name
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
}
