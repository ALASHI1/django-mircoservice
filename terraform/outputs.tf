output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.dj_docker.id
}

output "public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.dj_docker.public_ip
}

output "private_ip" {
  description = "The private IP address of the EC2 instance"
  value       = aws_instance.dj_docker.private_ip
}

output "availability_zone" {
  description = "The availability zone of the EC2 instance"
  value       = aws_instance.dj_docker.availability_zone
}

output "security_group_id" {
  description = "The ID of the security group attached to the EC2"
  value       = aws_security_group.dj_docker_sg.id
}

output "eip_public_ip" {
  value = aws_eip.dj_docker_eip.public_ip
}