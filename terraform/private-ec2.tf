data "aws_ami" "private-ubuntu-image" {
  most_recent = true
  owners = ["self"] # Looks for AMIs owned by your AWS account

  filter {
    name = "tag:Application"
    values = [var.ami_tag_private_ubuntu] # Matches the tag set in Packer
  }
}

resource "aws_instance" "private-ubuntu" {
  count                  = 3
  ami                    = data.aws_ami.private-ubuntu-image.id # AMI is baked with the public key
  instance_type          = "t2.micro"
  subnet_id              = module.vpc.private_subnets[0] # Bastion is in the private subnet
  vpc_security_group_ids = [aws_security_group.private_ec2_sg.id] # Security group for the bastion

  tags = {
    Name = "Private Ubuntu ${count.index + 1}"
  }
}

data "aws_ami" "private-amazon-image" {
  most_recent = true
  owners = ["self"] # Looks for AMIs owned by your AWS account

  filter {
    name = "tag:Application"
    values = [var.ami_tag_private_amazon] # Matches the tag set in Packer
  }
}

resource "aws_instance" "private-amazon" {
  count                  = 3
  ami                    = data.aws_ami.private-amazon-image.id # AMI is baked with the public key
  instance_type          = "t2.micro"
  subnet_id              = module.vpc.private_subnets[0] # Bastion is in the private subnet
  vpc_security_group_ids = [aws_security_group.private_ec2_sg.id] # Security group for the bastion

  tags = {
    Name = "Private Amazon Linux ${count.index + 1}"
  }
}