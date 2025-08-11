output "cluster_id" {
  description = "EKS cluster ID"
  value       = aws_eks_cluster.example.id
}

output "cluster_arn" {
  description = "EKS cluster ARN"
  value       = aws_eks_cluster.example.arn
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.example.endpoint
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = aws_eks_cluster.example.vpc_config[0].cluster_security_group_id
}

output "cluster_version" {
  description = "The Kubernetes version for the EKS cluster"
  value       = aws_eks_cluster.example.version
}

output "cluster_platform_version" {
  description = "Platform version for the EKS cluster"
  value       = aws_eks_cluster.example.platform_version
}

output "cluster_status" {
  description = "Status of the EKS cluster"
  value       = aws_eks_cluster.example.status
}

output "node_group_arn" {
  description = "Amazon Resource Name (ARN) of the EKS Node Group"
  value       = aws_eks_node_group.example.arn
}

output "node_group_status" {
  description = "Status of the EKS Node Group"
  value       = aws_eks_node_group.example.status
}

output "vpc_id" {
  description = "ID of the VPC where the cluster is deployed"
  value       = aws_vpc.example.id
}

output "eks_cluster_role_arn" {
  description = "ARN of the EKS cluster service role"
  value       = aws_iam_role.eks_role.arn
}

output "kubeconfig_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = aws_eks_cluster.example.certificate_authority[0].data
}