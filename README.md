# Ansible Project

## Step 1: Generate SSH Key Pair
Navigate to the root of the project directory and generate a key pair:
```sh
ssh-keygen -t rsa -b 4096 -f ansible-key
```

## Step 2: Configure AWS Credentials
Set up your AWS credentials in the environment:
```sh
export AWS_ACCESS_KEY_ID=<your-access-key-id>
export AWS_SECRET_ACCESS_KEY=<your-secret-access-key>
export AWS_SESSION_TOKEN=<your-session-token>
```

## Step 3: Build an AMI with Packer
Change to the `packer` directory:
```sh
cd packer
```
Run the Packer build command:
```sh
packer build ami-builder.pkr.hcl
```

## Step 4: Deploy Infrastructure with Terraform
Navigate to the `terraform` directory:
```sh
cd ../terraform
```
Expose your IP address to Terraform:
```sh
export TF_VAR_my_ip="$(curl -s https://checkip.amazonaws.com)/32"
```
Initialize and apply Terraform configuration:
```sh
terraform init
terraform plan
terraform apply
```

## Step 5: Configure and Run Ansible Playbook
Navigate to the `ansible` directory:
```sh
cd ../ansible
```
Export the public IP of the bastion host:
```sh
export BASTION_IP=<public-ip>
```
Add the SSH key to the agent:
```sh
ssh-add ../ansible-key
```
Run the Ansible playbook:
```sh
ansible-playbook -i inventory/aws_ec2.yml playbook.yml
```

