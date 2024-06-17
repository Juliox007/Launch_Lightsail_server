#!/bin/bash

###############################################################
# Author: HervÃ©
# Date:   6/16/24
#
# This script will create a aws ligthsail sever using terraform
#
# Version: V1
# ##############################################################

set -e

# Define variables
TERRAFORM_VERSION="4.61.0"
AWS_REGION="us-east-1"
LIGHTSAIL_INSTANCE_NAME="my-Script_lightsail-instance"
LIGHTSAIL_INSTANCE_BLUEPRINT="amazon_linux_2"  # Change this to your desired blueprint
LIGHTSAIL_INSTANCE_BUNDLE="nano_3_0"           # Change this to your desired bundle
KEY_PAIR_NAME="use your own key-pair here."                        # Change this to your key pair name

# Create a directory for the Terraform configuration
mkdir -p terraform-lightsail
cd terraform-lightsail

# Create Terraform configuration file
cat > main.tf <<EOL
provider "aws" {
  region = "${AWS_REGION}"
}

resource "aws_lightsail_instance" "script_instance" {
  name              = "${LIGHTSAIL_INSTANCE_NAME}"
  blueprint_id      = "${LIGHTSAIL_INSTANCE_BLUEPRINT}"
  bundle_id         = "${LIGHTSAIL_INSTANCE_BUNDLE}"
 availability_zone = "${AWS_REGION}a"
 key_pair_name     = "${KEY_PAIR_NAME}"

  tags = {
    Name = "TerraformLightsailInstance"
  }
}

output "my-public-ip" {
    value = aws_lightsail_instance.script_instance.public_ip_address
  
}

output "my_username" {
value = aws_lightsail_instance.script_instance.username
  
}
EOL

# Initialize Terraform
echo "Initializing Terraform..."
terraform init

# Apply the Terraform configuration
echo "Applying the Terraform configuration to create the Lightsail instance..."
terraform apply -auto-approve

# Output the instance details
echo "Lightsail instance '${LIGHTSAIL_INSTANCE_NAME}' has been created successfully."
terraform output