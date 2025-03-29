packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.0.0"
    }
  }
}

// Private instance: amazon docker AMI
source "amazon-ebs" "amazon_docker" {
  ami_name      = "amazon-docker-ami"
  instance_type = "t2.micro"
  region        = "us-east-1"

  tags = {
    Application = "amazon-docker-ami"
  }

  source_ami_filter {
    filters = {
      name                = "al2023-ami-2023*-x86_64"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  ssh_username = "ec2-user"
}

// Bastion host and private instance: ubuntu docker AMI
source "amazon-ebs" "ubuntu_docker" {
  ami_name      = "ubuntu-docker-ami"
  instance_type = "t2.micro"
  region        = "us-east-1"

  tags = {
    Application = "ubuntu-docker-ami"
  }

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  sources = [
    "source.amazon-ebs.amazon_docker",
    "source.amazon-ebs.ubuntu_docker"
  ]

  provisioner "file" {
    source      = "../ansible-key.pub"
    destination = "/tmp/ansible-key.pub"
  }

  // Provisioning for private instance: amazon docker
  provisioner "shell" {
    only = ["amazon-ebs.amazon_docker"]
    inline = [
      "sudo yum update -y",
      "sudo yum install -y docker",
      "sudo systemctl enable docker",
      "sudo systemctl start docker",
      "sudo usermod -a -G docker ec2-user",

      "mkdir -p /home/ec2-user/.ssh",
      "cat /tmp/ansible-key.pub >> /home/ec2-user/.ssh/authorized_keys",
      "chown -R ec2-user:ec2-user /home/ec2-user/.ssh",
      "chmod 700 /home/ec2-user/.ssh",
      "chmod 600 /home/ec2-user/.ssh/authorized_keys",

      "echo 'Setup complete' > /home/ec2-user/packer-log.txt"
    ]
  }

  // Provisioning for bastion host and private instance: ubuntu docker
  provisioner "shell" {
    only = ["amazon-ebs.ubuntu_docker"]
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y docker.io",
      "sudo systemctl enable docker",
      "sudo systemctl start docker",
      "sudo usermod -a -G docker ubuntu",

      "sudo apt-get install -y software-properties-common",
      "sudo add-apt-repository --yes --update ppa:ansible/ansible",
      "sudo apt-get install -y ansible",

      "mkdir -p /home/ubuntu/.ssh",
      "cat /tmp/ansible-key.pub >> /home/ubuntu/.ssh/authorized_keys",
      "chown -R ubuntu:ubuntu /home/ubuntu/.ssh",
      "chmod 700 /home/ubuntu/.ssh",
      "chmod 600 /home/ubuntu/.ssh/authorized_keys",

      "echo 'Setup complete' > /home/ubuntu/packer-log.txt"
    ]
  }
}