#!/bin/bash

# Exit on any error
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Terraform EKS Project Initialization ===${NC}"

# Check if required tools are installed
check_tool() {
    if ! command -v "$1" &> /dev/null; then
        echo -e "${RED}Error: $1 is not installed${NC}"
        exit 1
    else
        echo -e "${GREEN}✓ $1 is installed${NC}"
    fi
}

echo -e "${YELLOW}Checking required tools...${NC}"
check_tool "terraform"
check_tool "aws"
check_tool "kubectl"

# Check Terraform version
TERRAFORM_VERSION=$(terraform version -json | jq -r '.terraform_version')
echo -e "${GREEN}✓ Terraform version: $TERRAFORM_VERSION${NC}"

# Check AWS CLI configuration
echo -e "${YELLOW}Checking AWS credentials...${NC}"
if aws sts get-caller-identity > /dev/null 2>&1; then
    AWS_ACCOUNT=$(aws sts get-caller-identity --query Account --output text)
    AWS_USER=$(aws sts get-caller-identity --query Arn --output text)
    echo -e "${GREEN}✓ AWS credentials configured${NC}"
    echo -e "${GREEN}  Account: $AWS_ACCOUNT${NC}"
    echo -e "${GREEN}  User: $AWS_USER${NC}"
else
    echo -e "${RED}Error: AWS CLI is not configured or credentials are invalid${NC}"
    echo -e "${YELLOW}Please run: aws configure${NC}"
    exit 1
fi

# Navigate to terraform directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TERRAFORM_DIR="$(dirname "$SCRIPT_DIR")"
cd "$TERRAFORM_DIR"

echo -e "${YELLOW}Working directory: $(pwd)${NC}"

# Check if backend configuration exists
if [ -f "backend.tf" ]; then
    echo -e "${GREEN}✓ Backend configuration found${NC}"
    
    # Extract S3 bucket name from backend.tf if using S3 backend
    if grep -q "backend \"s3\"" backend.tf; then
        BUCKET_NAME=$(grep -A 10 "backend \"s3\"" backend.tf | grep "bucket" | sed 's/.*=\s*"\([^"]*\)".*/\1/')
        DYNAMODB_TABLE=$(grep -A 10 "backend \"s3\"" backend.tf | grep "dynamodb_table" | sed 's/.*=\s*"\([^"]*\)".*/\1/')
        AWS_REGION=$(grep -A 10 "backend \"s3\"" backend.tf | grep "region" | sed 's/.*=\s*"\([^"]*\)".*/\1/')
        
        echo -e "${YELLOW}Checking S3 backend prerequisites...${NC}"
        
        # Check if S3 bucket exists
        if aws s3 ls "s3://$BUCKET_NAME" > /dev/null 2>&1; then
            echo -e "${GREEN}✓ S3 bucket '$BUCKET_NAME' exists${NC}"
        else
            echo -e "${YELLOW}Creating S3 bucket '$BUCKET_NAME'...${NC}"
            aws s3 mb "s3://$BUCKET_NAME" --region "$AWS_REGION"
            
            # Enable versioning
            echo -e "${YELLOW}Enabling versioning on S3 bucket...${NC}"
            aws s3api put-bucket-versioning \
                --bucket "$BUCKET_NAME" \
                --versioning-configuration Status=Enabled
            
            echo -e "${GREEN}✓ S3 bucket created and configured${NC}"
        fi
        
        # Check if DynamoDB table exists
        if aws dynamodb describe-table --table-name "$DYNAMODB_TABLE" --region "$AWS_REGION" > /dev/null 2>&1; then
            echo -e "${GREEN}✓ DynamoDB table '$DYNAMODB_TABLE' exists${NC}"
        else
            echo -e "${YELLOW}Creating DynamoDB table '$DYNAMODB_TABLE'...${NC}"
            aws dynamodb create-table \
                --table-name "$DYNAMODB_TABLE" \
                --attribute-definitions AttributeName=LockID,AttributeType=S \
                --key-schema AttributeName=LockID,KeyType=HASH \
                --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1 \
                --region "$AWS_REGION"
            
            echo -e "${YELLOW}Waiting for DynamoDB table to be created...${NC}"
            aws dynamodb wait table-exists --table-name "$DYNAMODB_TABLE" --region "$AWS_REGION"
            echo -e "${GREEN}✓ DynamoDB table created${NC}"
        fi
    fi
else
    echo -e "${YELLOW}⚠ No backend configuration found. Using local backend.${NC}"
fi

# Initialize Terraform
echo -e "${YELLOW}Initializing Terraform...${NC}"
terraform init

# Validate configuration
echo -e "${YELLOW}Validating Terraform configuration...${NC}"
terraform validate

# Format Terraform files
echo -e "${YELLOW}Formatting Terraform files...${NC}"
terraform fmt

# Create terraform.tfvars if it doesn't exist
if [ ! -f "terraform.tfvars" ]; then
    echo -e "${YELLOW}Creating terraform.tfvars template...${NC}"
    cat > terraform.tfvars << EOF
# EKS Cluster Configuration
cluster_name = "my-eks-cluster"
aws_region   = "us-west-2"
vpc_cidr     = "10.0.0.0/16"

# Node Group Configuration
node_group_desired_size = 2
node_group_max_size     = 4
node_group_min_size     = 1

# Kubernetes Version
kubernetes_version = "1.28"
EOF
    echo -e "${GREEN}✓ terraform.tfvars template created${NC}"
    echo -e "${YELLOW}Please review and update terraform.tfvars with your desired values${NC}"
fi

echo -e "${GREEN}=== Initialization Complete ===${NC}"
echo -e "${YELLOW}Next steps:${NC}"
echo -e "1. Review and update terraform.tfvars"
echo -e "2. Run: ./scripts/plan.sh to see what will be created"
echo -e "3. Run: ./scripts/apply.sh to deploy the infrastructure"