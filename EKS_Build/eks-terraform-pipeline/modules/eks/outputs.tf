output "cluster_id" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.this.id
}

output "cluster_endpoint" {
  description = "Endpoint for the EKS cluster"
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_arn" {
  description = "ARN of the EKS cluster"
  value       = aws_eks_cluster.this.arn
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

output "node_group_id" {
  description = "ID of the EKS node group"
  value       = aws_eks_node_group.this.id
}

output "node_group_arn" {
  description = "ARN of the EKS node group"
  value       = aws_eks_node_group.this.arn
}