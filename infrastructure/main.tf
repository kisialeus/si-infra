module "vpc" {
  source          = "../modules/vpc"
  aws_region      = var.aws_region
  project_prefix  = var.project_prefix
  environment     = var.environment
  az_count        = var.vpc.az_count
  vpc_cidr        = var.vpc.vpc_cidr
  private_subnets = var.vpc.private_subnets
  public_subnets  = var.vpc.public_subnets

  common_tags = var.common_tags
}

module "ecr" {
  source         = "../modules/ecr"
  ecr_repos      = var.ecr_repos
  project_prefix = var.project_prefix
  common_tags    = var.common_tags
}

module "eks" {
  source          = "../modules/eks"
  aws_region      = var.aws_region
  project_prefix  = var.project_prefix
  environment     = var.environment
  vpc_id          = module.vpc.vpc_id
  cluster_version = var.eks.cluster_version
  eks_nodegroups  = var.eks.eks_nodegroups
  private_subnets = module.vpc.private_subnets_ids
  public_subnets  = module.vpc.public_subnets_ids


  common_tags = var.common_tags
  depends_on  = [
    module.vpc
  ]
}

module "cluster_addons" {
  source         = "../modules/eks-addons"
  aws_region     = var.aws_region
  project_prefix = var.project_prefix
  domain_name    = var.domain_name
  environment    = var.environment
  role_arns      = {
    aws_load_balancer_controller_irsa_role = module.eks.aws_load_balancer_controller_irsa_role
    argocd_image_updater_irsa_role         = module.eks.argocd_image_updater_irsa_role
  }
  versions         = var.eks_addons_helm_versions
  eks_cluster_name = module.eks.cluster_name
}

module "argocd-app" {
  source           = "../modules/argo-app-si"
  eks_cluster_name = module.eks.cluster_name
  domain_name    = var.domain_name
  app_name         = var.app_name
}
