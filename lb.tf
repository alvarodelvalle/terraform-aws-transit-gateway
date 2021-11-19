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

# TODO - maybe use this for firewall instances
#resource "aws_lb_target_group" "instance" {
#  for_each    = { for k, v in local.lb_targets : k => v if v.target_type == "ip" }
#  name        = each.value.target_key
#  target_type = "ip"
#  protocol    = "HTTP"
#  vpc_id      = aws_vpc.this[each.value.vpc_name].id
#  health_check {
#    path = "/"
#    matcher = "200-499"
#  }
#}

resource "aws_lb_target_group" "ip" {
  for_each    = { for k, v in local.lb_targets : k => v if v.target_type == "ip" }
  name        = each.value.target_key
  target_type = "ip"
  protocol    = "HTTP"
  vpc_id      = aws_vpc.this[each.value.vpc_name].id
  health_check {
    path = "/"
    matcher = "200-499"
  }
}

## TODO - This is going to need a `depends_on` to the firewall deployments.
## Use this for gwlb-target-security-us-east targeting IP's
## Use this for targets for alb-target-inbound-app1-us-east and alb-target-inbound-app2-us-east
## Evaluate if this is going to be used for firewall instances
#resource "aws_lb_target_group_attachment" "this" {
#  target_group_arn = ""
#  target_id        = ""
#}

resource "aws_lb_listener" "this" {
  for_each = local.lb_listeners
  load_balancer_arn = aws_lb.this[each.value.lb_key].arn
  port              = each.value.port
  protocol          = each.value.protocol
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ip[each.value.target_group].arn
  }
}
