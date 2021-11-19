resource "aws_lb" "this" {
  for_each                         = var.elbs
  load_balancer_type               = each.value.type
  name                             = each.key
  subnets                          = [ for x in each.value.subnets : data.aws_subnets.this[x].ids ][0]
  enable_cross_zone_load_balancing = lookup(each.value, "cross-zone", null)
  tags = merge(
  {
    "Name" = each.key
  },
  var.tags,
  each.value.tags
  )
}


resource "aws_lb_target_group" "ip" {
  for_each    = { for k, v in local.lb_targets : k => v if v.target_type == "ip" }
  name        = each.value.target_key
  target_type = "ip"
  protocol    = "HTTP"
  vpc_id      = aws_vpc.this[each.value.vpc_name].id
}

# TODO - do these after firewall registration. This is going to need a `depends_on`
#resource "aws_lb_target_group_attachment" "this" {
#  target_group_arn = ""
#  target_id        = ""
#}
