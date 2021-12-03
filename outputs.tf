output "PAN-instances" {
  value = aws_instance.pan.*
}

output "lb-dns" {
  value = aws_lb.this.*.dns_name
}

