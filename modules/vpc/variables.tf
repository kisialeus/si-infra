variable "aws_region" {
  type        = string
  description = "AWS region to deploy"
}

variable "project_prefix" {
  type        = string
  description = "Short name of the project used as a prefix for resources"
}

variable "environment" {
  type        = string
  description = "Infrastructure environment"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR Block"
}

variable "az_count" {
  description = "Number of availability zones"
  type        = number
  default     = 3
}

variable "public_subnets" {
  type        = list(string)
  description = "List public subnets"
}

variable "private_subnets" {
  type        = list(string)
  description = "List private subnets"
}

variable "common_tags" {
  type        = map(string)
  description = "Tags for infrastructure resources."
}
