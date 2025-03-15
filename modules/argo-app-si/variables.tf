variable "eks_cluster_name" {
  type = string
  description = "EKS cluster name"
}

variable "domain_name" {
  type        = string
  description = "Name of domanin to work with external DNS"
}

variable "app_name" {
  type        = string
  description = "Name of App to  create cert"
}
