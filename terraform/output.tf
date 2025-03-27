output "bastion_public_ip" {
  description = "The public IP of the bastion host"
  value       = aws_eip.bastion_eip.public_ip
}

output "private_amazon_machine_ips" {
  description = "Private IPs of the 3 amazon linux machines"
  value       = aws_instance.private-amazon[*].private_ip
}

output "private_ubuntu_machine_ips" {
  description = "Private IPs of the 3 ubuntu machines"
  value       = aws_instance.private-ubuntu[*].private_ip
}