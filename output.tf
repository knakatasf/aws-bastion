output "bastion_public_ip" {
  description = "The public IP of the bastion host"
  value       = aws_eip.bastion_eip.public_ip
}

output "private_instance_ips" {
  description = "Private IPs of the 6 EC2 instances"
  value       = aws_instance.private-ec2[*].private_ip
}