locals {
  module_name = "terraform-aws-transit-gateway"
  lb_targets = flatten([
    for lb_key, lb in var.elbs : [
      for t_key, t in lb.targets : {
        lb_key      = lb_key
        target_key  = t_key
        target_type = t.type
        targets     = t.targets
        vpc_name    = lb.vpc_name
      }
    ]
  ])
}
