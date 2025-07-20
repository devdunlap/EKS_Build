#!/bin/bash

# Exit on any error
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Starting Terraform Apply Process...${NC}"

# Check if AWS CLI is configured
if ! aws sts get-caller-identity > /dev/null 2>&1; then
    echo -e "${RED}Error: AWS CLI is not configured or credentials are invalid${NC}"
    exit 1
fi

echo -e "${GREEN}AWS credentials verified${NC}"

# Navigate to the terraform directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TERRAFORM_DIR="$(dirname "$SCRIPT_DIR")"
cd "$TERRAFORM_DIR"

echo -e "${YELLOW}Current directory: $(pwd)${NC}"

# Initialize Terraform
echo -e "${YELLOW}Initializing Terraform...${NC}"
terraform init

# Validate Terraform configuration
echo -e "${YELLOW}Validating Terraform configuration...${NC}"
terraform validate

# Format Terraform files
echo -e "${YELLOW}Formatting Terraform files...${NC}"
terraform fmt

# Plan the deployment
echo -e "${YELLOW}Creating Terraform plan...${NC}"
terraform plan -out=tfplan

# Ask for confirmation before applying
echo -e "${YELLOW}Do you want to apply the Terraform plan? (yes/no)${NC}"
read -r response
if [[ "$response" != "yes" ]]; then
    echo -e "${RED}Deployment cancelled${NC}"
    rm -f tfplan
    exit 0
fi

# Apply the plan
echo -e "${YELLOW}Applying Terraform plan...${NC}"
terraform apply tfplan

# Clean up plan file
rm -f tfplan

# Display outputs
echo -e "${GREEN}Deployment completed successfully!${NC}"
echo -e "${YELLOW}Terraform outputs:${NC}"
terraform output

# Generate kubeconfig
echo -e "${YELLOW}Updating kubeconfig...${NC}"
CLUSTER_NAME=$(terraform output -raw cluster_id 2>/dev/null || echo "")
AWS_REGION=$(terraform output -raw aws_region 2>/dev/null || echo "us-west-2")

if [ -n "$CLUSTER_NAME" ]; then
    aws eks update-kubeconfig --region "$AWS_REGION" --name "$CLUSTER_NAME"
    echo -e "${GREEN}Kubeconfig updated for cluster: $CLUSTER_NAME${NC}"
else
    echo -e "${YELLOW}Could not determine cluster name from outputs${NC}"
fi

echo -e "${GREEN}Script completed successfully!${NC}"