variable "cluster_role_name" {
  description = "Name for the EKS cluster IAM role"
  type        = string
}

variable "node_role_name" {
  description = "Name for the EKS node group IAM role"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default     = {}
}