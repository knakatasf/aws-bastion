variable "my_ip" {
  description = "Your machine's IP address that is allowed to ssh into the bastions and private EC2s."
  type        = string
 }

variable "ami_tag_bastion" {
  description = "The tag of the AMI that Bastion instance will use."
  type        = string
  default     = "ubuntu-docker-ami"
}

variable "ami_tag_private_ubuntu" {
  description = "The tag of the AMI that private ubuntu machine will use."
  type        = string
  default     = "ubuntu-docker-ami"
}

variable "ami_tag_private_amazon" {
  description = "The tag of the AMI that private amazon machine will use."
  type        = string
  default     = "amazon-docker-ami"
}

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "my-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "aws_azs" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "aws_public_subnet_cidr" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "aws_private_subnet_cidr" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_key" {
  description = "Public key for SSH access"
  type        = string
  default     = "aws-key"
}

variable "resource_tags" {
  description = "Tags for AWS resources"
  type        = map(string)
  default     = {
    Project   = "TerraformAssignment"
    ManagedBy = "Terraform"
  }
}