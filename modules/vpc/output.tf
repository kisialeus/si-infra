output "vpc_id" {
  description = "The ID of the VPC"
  value       = try(module.cluster_vpc.vpc_id, "")
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = try(module.cluster_vpc.vpc_arn, "")
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = try(module.cluster_vpc.vpc_cidr_block, "")
}

output "private_subnets_ids" {
  description = "List of IDs of private subnets"
  value       = module.cluster_vpc.private_subnets
}

output "private_subnet_arns" {
  description = "List of ARNs of private subnets"
  value       = module.cluster_vpc.private_subnet_arns
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = module.cluster_vpc.private_subnets_cidr_blocks
}

output "public_subnets_ids" {
  description = "List of IDs of public subnets"
  value       = module.cluster_vpc.public_subnets
}

output "public_subnet_arns" {
  description = "List of ARNs of public subnets"
  value       = module.cluster_vpc.public_subnet_arns
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = module.cluster_vpc.public_subnets_cidr_blocks
}
