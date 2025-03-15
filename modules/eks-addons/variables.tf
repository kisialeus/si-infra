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
  description = "Name of domanin to work with external DNS"
}

variable "eks_cluster_name" {
  type = string
  description = "EKS cluster name"
}

variable "role_arns" {
  type = object({
    aws_load_balancer_controller_irsa_role = string
    argocd_image_updater_irsa_role = string
  })
}

variable "versions" {
  type = object({
    external_dns          = optional(string, "v0.11.0")
    argo_cd               = optional(string, "7.8.10")
    argo_cd_image_updater = optional(string, "0.12.0")
    alb_controller        = optional(string, "1.11.0")
  })
}
