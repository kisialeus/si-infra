data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "default" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "default" {
  name = var.eks_cluster_name
}

data "aws_route53_zone" "domain" {
  name         = var.domain_name
  private_zone = false
}
