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

variable "domain_name" {
  type        = string
  description = "Domain name"
}

variable "app_name" {
  type        = string
  description = "App name"
}


variable "vpc" {
  type = object({
    vpc_cidr        = string
    public_subnets  = list(string)
    private_subnets = list(string)
    az_count        = optional(string, 3)
  })
  description = "VPC configuration"
}

variable "ecr_repos" {
  description = "List of ECR repositories to create"
}

variable "eks_addons_helm_versions" {
  type = object({
    external_dns          = optional(string, "v0.11.0")
    argo_cd               = optional(string, "7.8.10")
    argo_cd_image_updater = optional(string, "0.12.0")
    alb_controller        = optional(string, "1.11.0")
  })
  description = "List of addons versions"
}


variable "eks" {
  type = object({
    cluster_version = string
    eks_nodegroups  = list(object({
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
  })
  description = "EKS cluster configuration"
}

variable "common_tags" {
  type        = map(string)
  description = "Tags for infrastructure resources."
}
