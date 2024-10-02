output "public_subnet_ids" {
  value       = aws_subnet.public_subnets[*].id
  description = "The ID of the public subnet."
}

output "private_subnet_ids" {
  value       = aws_subnet.private_subnets[*].id
  description = "The ID of the private subnet."
}

output "web_alb" {
  value       = aws_lb.web_alb.dns_name
  description = "Web Application Load Balancer URL"

}
