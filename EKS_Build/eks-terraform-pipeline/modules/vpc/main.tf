data "aws_availability_zones" "available" {
	state = "available"
}

# VPC
resource "aws_vpc" "this" {
	cidr_block           = var.vpc_cidr
	enable_dns_hostnames = true
	enable_dns_support   = true
	tags = {
		Name = var.vpc_name
	}
}

# Internet Gateway
resource "aws_internet_gateway" "this" {
	vpc_id = aws_vpc.this.id
	tags = {
		Name = "${var.vpc_name}-igw"
	}
}

# Public Subnets
resource "aws_subnet" "public" {
	count = var.public_subnet_count
	vpc_id                  = aws_vpc.this.id
	cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
	availability_zone       = data.aws_availability_zones.available.names[count.index]
	map_public_ip_on_launch = true
	tags = {
		Name = "${var.vpc_name}-public-${count.index + 1}"
	}
}

# Route Table
resource "aws_route_table" "public" {
	vpc_id = aws_vpc.this.id
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.this.id
	}
	tags = {
		Name = "${var.vpc_name}-public-rt"
	}
}

# Route Table Association
resource "aws_route_table_association" "public" {
	count = var.public_subnet_count
	subnet_id      = aws_subnet.public[count.index].id
	route_table_id = aws_route_table.public.id
}
