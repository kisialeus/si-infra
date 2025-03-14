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

variable "vpc_id" {
  description = "VPC ID"
}

variable "public_subnets" {
  type        = list(string)
  description = "EKS cluster public subnets"
}

variable "private_subnets" {
  type        = list(string)
  description = "EKS cluster private subnets"
}

variable "cluster_version" {
  type        = string
  description = "Cluster version"
}

#variable "domain_name" {
#  type        = string
#  description = "Name of domanin to work with external DNS"
#}

variable "eks_nodegroups" {
  type = list(object({
    name                         = string
    is_spot                      = bool
    type                         = optional(string, "general")
    min_size                     = number
    max_size                     = number
    desired_size                 = number
    volume_size                  = optional(number)
    volume_type                  = optional(string, "gp3")
    delete_volume_on_termination = optional(bool, true)
    custom_label                 = optional(string)
    instance_types               = optional(list(string))
    ami_type                     = optional(string)
    single_az                    = optional(bool, false)
  }))
}

#variable "versions" {
#  type = list(object({
#    external_dns          = optional(string, "v0.11.0")
#    argo_cd               = optional(string, "7.8.10")
#    argo_cd_image_updater = optional(string, "0.12.0")
#    alb_controller        = optional(string, "1.11.0")
#  }))
#
#}

variable "common_tags" {
  type        = map(string)
  description = "Tags for infrastructure resources."
}
