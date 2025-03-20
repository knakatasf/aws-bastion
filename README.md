# aws-bastion


cd <project directory>

Install Packer and Terraform

brew tap hashicorp/tap
brew install hashicorp/tap/packer
brew install hashicorp/tap/terraform

Generate an SSH key pair

ssh-keygen -t rsa -b 4096 -f aws-key

Load AWS credentials. These values are automatically read by Packer and Terraform.

export AWS_ACCESS_KEY_ID=<???>
export AWS_SECRET_ACCESS_KEY=<???>
export AWS_SESSION_TOKEN=<???>

Run the Packer script
packer build packer-ami.pkr.hcl

