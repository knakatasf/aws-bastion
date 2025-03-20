module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs  = var.aws_azs

  private_subnets = var.aws_private_subnet_cidr
  public_subnets  = var.aws_public_subnet_cidr  # Internet Gateway is created automatically by VPC

  # NAT Gateway for Public Subnet
  enable_nat_gateway      = true
  single_nat_gateway      = true
  one_nat_gateway_per_az  = false

  # Use the created EIP for the NAT
  reuse_nat_ips           = true
  external_nat_ip_ids     = aws_eip.nat.*.id

  enable_dns_hostnames = true

  # Tags for resources
  public_subnet_tags  = var.resource_tags
  private_subnet_tags = var.resource_tags
  tags                = var.resource_tags
  vpc_tags            = var.resource_tags
}

# Create an EIP for the NAT
resource "aws_eip" "nat" {
  count = 1
  vpc   = true
}
