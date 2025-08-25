variable "vpc_cidr" {
	description = "CIDR block for the VPC"
	type        = string
}

variable "vpc_name" {
	description = "Name tag for the VPC and related resources"
	type        = string
}

variable "public_subnet_count" {
	description = "Number of public subnets to create"
	type        = number
	default     = 2
}
