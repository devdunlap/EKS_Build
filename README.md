<<<<<<< HEAD
# EKS Terraform Pipeline

This repository contains a complete Infrastructure as Code (IaC) solution for deploying Amazon EKS (Elastic Kubernetes Service) clusters using Terraform and Jenkins CI/CD pipeline.

## 📁 Project Structure

```
eks-terraform-pipeline/
├── .gitignore                   # Git ignore patterns
├── Jenkinsfile                  # Jenkins CI/CD pipeline configuration
├── README.md                    # Project documentation
├── terraform.tfvars             # Terraform variable overrides
├── backend.tf                   # Remote state configuration (S3 + DynamoDB)
├── provider.tf                  # AWS provider setup
├── variables.tf                 # Root-level variables
├── main.tf                      # Root-level orchestration
├── outputs.tf                   # Root-level outputs
├── modules/
│   ├── vpc/                     # VPC networking module
│   ├── eks/                     # EKS cluster and node groups
│   ├── iam/                     # IAM roles and policies
├── jenkins/
│   ├── Dockerfile               # Custom Jenkins image with tools
│   ├── plugins.txt              # Jenkins plugins list
│   └── seed-job.groovy          # Seed job configuration
└── scripts/
    ├── init.sh                  # Terraform initialization
    ├── plan.sh                  # Terraform plan execution
    ├── apply.sh                 # Terraform apply execution
    └── destroy.sh               # Terraform destroy execution
```

## 🏗️ Architecture Overview

This project creates a complete EKS infrastructure including:

- **VPC Module**: Creates networking infrastructure (subnets, route tables, internet gateway)
- **IAM Module**: Sets up required IAM roles and policies for EKS cluster and worker nodes
- **EKS Module**: Deploys the EKS cluster and managed node groups

## 🚀 Key Components

### Terraform Modules

#### VPC Module (`modules/vpc/`)
- Creates VPC with public and private subnets
- Configures routing and internet gateway
- Sets up security groups for EKS

#### IAM Module (`modules/iam/`)
- **EKS Cluster Role**: Service role for EKS cluster operations
- **Node Group Role**: Role for EC2 worker nodes
- **Policy Attachments**: Required AWS managed policies

#### EKS Module (`modules/eks/`)
- **EKS Cluster**: Kubernetes control plane
- **Node Groups**: Managed worker nodes with auto-scaling
- **Configuration**: Kubernetes version, instance types, scaling parameters

### Jenkins Pipeline (`Jenkinsfile`)

The CI/CD pipeline includes these stages:

1. **Checkout**: Pulls code from SCM
2. **Terraform Init**: Initializes Terraform backend
3. **Terraform Plan**: Creates execution plan
4. **Terraform Apply**: Deploys infrastructure (main branch only with approval)

### Custom Jenkins Image (`jenkins/Dockerfile`)

Includes essential tools:
- **Docker CLI**: For container operations
- **Terraform**: Infrastructure as Code tool
- **kubectl**: Kubernetes command-line tool

## 🔧 Key Features

- **Modular Design**: Reusable Terraform modules
- **Remote State**: S3 backend with DynamoDB locking
- **CI/CD Integration**: Automated deployment via Jenkins
- **Security**: IAM roles with least privilege principles
- **Scalability**: Auto-scaling node groups
- **Monitoring**: Tagged resources for cost tracking

## 📋 Prerequisites

- AWS Account with appropriate permissions
- Jenkins server (or ability to build custom Jenkins image)
- S3 bucket for Terraform state
- DynamoDB table for state locking

## 🚀 Getting Started

1. **Configure AWS Credentials**
2. **Set up S3 backend** in `backend.tf`
3. **Customize variables** in `terraform.tfvars`
4. **Run the pipeline** through Jenkins or use the provided scripts

## 🔍 Monitoring and Management

- All resources are tagged for easy identification
- Node groups support auto-scaling based on demand
- EKS cluster supports both public and private API endpoints

## 🛠️ Scripts

Helper scripts in the `scripts/` directory provide:
- **init.sh**: Initialize Terraform with backend configuration
- **plan.sh**: Run Terraform plan with validation and formatting
- **apply.sh**: Apply infrastructure changes
- **destroy.sh**: Clean up resources when needed

This repository provides a production-ready foundation for deploying and managing EKS clusters with proper CI/CD practices
=======
add new read me

>>>>>>> 6508361 ( updated read me)
