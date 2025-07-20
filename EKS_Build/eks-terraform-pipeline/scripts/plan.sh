#!/bin/bash

# Exit on any error
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Terraform Plan ===${NC}"

# Check if AWS CLI is configured
if ! aws sts get-caller-identity > /dev/null 2>&1; then
    echo -e "${RED}Error: AWS CLI is not configured or credentials are invalid${NC}"
    exit 1
fi

echo -e "${GREEN}✓ AWS credentials verified${NC}"

# Navigate to the terraform directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TERRAFORM_DIR="$(dirname "$SCRIPT_DIR")"
cd "$TERRAFORM_DIR"

echo -e "${YELLOW}Working directory: $(pwd)${NC}"

# Check if terraform is initialized
if [ ! -d ".terraform" ]; then
    echo -e "${YELLOW}Terraform not initialized. Running terraform init...${NC}"
    terraform init
fi

# Validate Terraform configuration
echo -e "${YELLOW}Validating Terraform configuration...${NC}"
terraform validate

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Configuration is valid${NC}"
else
    echo -e "${RED}✗ Configuration validation failed${NC}"
    exit 1
fi

# Format Terraform files
echo -e "${YELLOW}Formatting Terraform files...${NC}"
terraform fmt

# Check if terraform.tfvars exists
if [ ! -f "terraform.tfvars" ]; then
    echo -e "${YELLOW}⚠ terraform.tfvars not found. Using default values.${NC}"
    echo -e "${YELLOW}Consider creating terraform.tfvars for custom configurations.${NC}"
fi

# Run terraform plan
echo -e "${YELLOW}Creating Terraform execution plan...${NC}"
echo -e "${BLUE}This will show what Terraform will do when applied.${NC}"

# Option to save plan to file
read -p "$(echo -e ${YELLOW}Save plan to file? [y/N]: ${NC})" -r save_plan

if [[ $save_plan =~ ^[Yy]$ ]]; then
    PLAN_FILE="tfplan-$(date +%Y%m%d-%H%M%S)"
    echo -e "${YELLOW}Saving plan to: $PLAN_FILE${NC}"
    terraform plan -out="$PLAN_FILE"
    echo -e "${GREEN}✓ Plan saved to $PLAN_FILE${NC}"
    echo -e "${YELLOW}To apply this plan, run: terraform apply $PLAN_FILE${NC}"
else
    terraform plan
fi

# Show resource count summary
echo -e "${BLUE}=== Plan Summary ===${NC}"
PLAN_OUTPUT=$(terraform plan -no-color 2>/dev/null || echo "Failed to get plan summary")

if echo "$PLAN_OUTPUT" | grep -q "Plan:"; then
    SUMMARY=$(echo "$PLAN_OUTPUT" | grep "Plan:" | tail -1)
    echo -e "${GREEN}$SUMMARY${NC}"
else
    echo -e "${YELLOW}No changes detected or plan summary unavailable${NC}"
fi

# Check for any warnings or errors
if echo "$PLAN_OUTPUT" | grep -q "Warning:"; then
    echo -e "${YELLOW}⚠ Warnings detected in plan. Please review above.${NC}"
fi

echo -e "${GREEN}=== Plan Complete ===${NC}"
echo -e "${YELLOW}Next steps:${NC}"
echo -e "1. Review the plan output above"
echo -e "2. If everything looks correct, run: ./scripts/apply.sh"
echo -e "3. To destroy resources later, run: ./scripts/destroy.sh"