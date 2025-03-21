resource "aws_instance" "private-ec2" {
  count                  = 6
  ami                    = var.ami_id # AMI is baked with the public key
  instance_type          = "t2.micro"
  subnet_id              = module.vpc.private_subnets[0] # Bastion is in the private subnet
  vpc_security_group_ids = [aws_security_group.private_ec2_sg.id] # Security group for the bastion

  tags = {
    Name = "Private EC2 ${count.index + 1}"
  }
}