# Project Configuration
cluster_name = "my-eks-cluster"
aws_region   = "us-west-2"

# VPC Configuration
vpc_cidr = "10.0.0.0/16"

# EKS Node Group Configuration
node_group_desired_size = 2
node_group_max_size     = 4
node_group_min_size     = 1

# Kubernetes Configuration
kubernetes_version = "1.28"

# Additional configuration for production
# Uncomment and modify as needed:
# aws_region = "us-east-1"
# vpc_cidr = "172.16.0.0/16"
# cluster_name = "production-eks"
# kubernetes_version = "1.29"