packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.0.0"
    }
  }
}

// Bastion: ubuntu ansible AMI
source "amazon-ebs" "ubuntu_ansible" {
  ami_name      = "ubuntu-ansible-ami"
  instance_type = "t2.micro"
  region        = "us-east-1"

  tags = {
    Application = "ubuntu-ansible-ami"
  }

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
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
      name                = "amzn2-ami-hvm-*-x86_64-gp2"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  ssh_username = "ec2-user"
}

// Private instance: ubuntu docker AMI
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

// Build all AMIs concurrently
build {
  sources = [
    "source.amazon-ebs.ubuntu_ansible",
    "source.amazon-ebs.amazon_docker",
    "source.amazon-ebs.ubuntu_docker"
  ]

  // Distribute public key to each AMI
  provisioner "file" {
    source      = "../aws-key.pub"
    destination = "/tmp/aws-key.pub"
  }

  // Provisioning for bastion host: ubuntu ansible
  provisioner "shell" {
    only = ["source.amazon-ebs.ubuntu_ansible"]
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y docker.io ansible",
      "sudo systemctl enable docker",
      "sudo systemctl start docker",
      "sudo usermod -a -G docker ubuntu",

      "mkdir -p /home/ubuntu/.ssh",
      "cat /tmp/aws-key.pub >> /home/ubuntu/.ssh/authorized_keys",
      "chown -R ubuntu:ubuntu /home/ubuntu/.ssh",
      "chmod 700 /home/ubuntu/.ssh",
      "chmod 600 /home/ubuntu/.ssh/authorized_keys",

      "echo 'Setup complete' > /home/ubuntu/packer-log.txt"
    ]
  }

  // Provisioning for private instance: amazon docker
  provisioner "shell" {
    only = ["source.amazon-ebs.amazon_docker"]
    inline = [
      "sudo yum update -y",
      "sudo yum install -y docker",
      "sudo systemctl enable docker",
      "sudo systemctl start docker",
      "sudo usermod -a -G docker ec2-user",

      "mkdir -p /home/ec2-user/.ssh",
      "cat /tmp/aws-key.pub >> /home/ec2-user/.ssh/authorized_keys",
      "chown -R ec2-user:ec2-user /home/ec2-user/.ssh",
      "chmod 700 /home/ec2-user/.ssh",
      "chmod 600 /home/ec2-user/.ssh/authorized_keys",

      "echo 'Setup complete' > /home/ec2-user/packer-log.txt"
    ]
  }

  // Provisioning for private instance: ubuntu docker
  provisioner "shell" {
    only = ["source.amazon-ebs.ubuntu_docker"]
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y docker.io",
      "sudo systemctl enable docker",
      "sudo systemctl start docker",
      "sudo usermod -a -G docker ubuntu",

      "mkdir -p /home/ubuntu/.ssh",
      "cat /tmp/aws-key.pub >> /home/ubuntu/.ssh/authorized_keys",
      "chown -R ubuntu:ubuntu /home/ubuntu/.ssh",
      "chmod 700 /home/ubuntu/.ssh",
      "chmod 600 /home/ubuntu/.ssh/authorized_keys",

      "echo 'Setup complete' > /home/ubuntu/packer-log.txt"
    ]
  }
}