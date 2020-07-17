output "alb_endpoint" {
  value = aws_alb.this.dns_name
}

output "alb_zone_id" {
  value = aws_alb.this.zone_id
}
