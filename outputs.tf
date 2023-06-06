output "id" {
  description = "Outputs the ID of the EC2 instance."
  value       = aws_instance.default.id
}

output "name" {
  description = "Outputs the name of the EC2 instance."
  value       = aws_instance.default.tags.Name
}

output "private_ip" {
  description = "Outputs the private IP of the EC2 instance."
  value       = aws_instance.default.private_ip
}

output "availability_zone" {
  description = "Outputs the availability zone of the EC2 instance."
  value       = aws_instance.default.availability_zone
}
