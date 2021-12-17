resource "aws_network_interface" "this" {
  for_each          = { for k, v in local.instance_enis : v.eni_name => v }
  subnet_id         = data.aws_subnets.this[each.value.subnet].ids[0]
  private_ips       = each.value.ips
  security_groups   = [for x in each.value.security_groups : aws_security_group.this[x].id]
  source_dest_check = each.value.src_dst_check
  tags = merge(
    { Name = each.value.eni_name },
    var.tags
  )
}

resource "aws_instance" "pan" {
  for_each          = var.instances
  instance_type     = each.value.instance_type
  ami               = "ami-0d952f6fcedfc9e56"
  user_data         = ""
  availability_zone = each.value.az
  key_name          = each.value.key_name
  dynamic "network_interface" {
    for_each = each.value.network_interfaces
    content {
      device_index         = network_interface.value.index
      network_interface_id = aws_network_interface.this[network_interface.key].id
    }
  }
  tags = merge(
    { Name = each.key },
    var.tags
  )
}

resource "aws_eip" "this" {
  for_each                  = var.eips
  vpc                       = true
  network_interface         = aws_network_interface.this[each.value.allocation].id
  associate_with_private_ip = aws_network_interface.this[each.value.allocation].private_ip
  tags = merge(
    { Name = each.key },
    var.tags
  )
}
