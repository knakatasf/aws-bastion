# AWS Bastion Setup

This guide provides step-by-step instructions to set up an AWS Bastion host using Packer and Terraform.

## Prerequisites
- macOS with **Homebrew** installed
- AWS credentials with sufficient permissions
- [Packer](https://developer.hashicorp.com/packer) and [Terraform](https://developer.hashicorp.com/terraform)

## Installation

### 1. Clone the Project and Navigate to the Directory
```sh
cd <project-directory>
```

### 2. Install Packer and Terraform
Run the following commands to install the necessary tools:
```sh
brew tap hashicorp/tap  
brew install hashicorp/tap/packer  
brew install hashicorp/tap/terraform  
```

### 3. Generate an SSH Key Pair
Create an RSA key pair for secure access:
```sh
ssh-keygen -t rsa -b 4096 -f aws-key
```

### 4. Configure AWS Credentials
Export your AWS credentials for authentication:
```sh
export AWS_ACCESS_KEY_ID=<your-access-key-id>  
export AWS_SECRET_ACCESS_KEY=<your-secret-access-key>  
export AWS_SESSION_TOKEN=<your-session-token>  
```

### 5. Build the AWS AMI with Packer
Run the Packer script to create a custom AMI:
```sh
packer build packer-ami.pkr.hcl
```

## Next Steps
- Deploy the infrastructure using Terraform
- Configure security groups and IAM roles
- Connect to the bastion host via SSH
  ssh -i aws-key ec2-user@44.201.179.207


## Resources
- [Packer Documentation](https://developer.hashicorp.com/packer)
- [Terraform Documentation](https://developer.hashicorp.com/terraform)
- [AWS CLI Guide](https://docs.aws.amazon.com/cli/latest/userguide/)

---

**Author:** *Koichi Nakata*