aws_region     = "eu-central-1"
project_prefix = "si"
environment    = "hometask"
domain_name    = "kisialeu.com"
app_name       = "si"
ecr_repos      = ["simplesurance"]

vpc = {
  vpc_cidr               = "10.0.0.0/16"
  public_subnets         = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets        = ["10.0.3.0/24", "10.0.4.0/24"]
  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true
  az_count               = 2
}

eks_addons_helm_versions = {
  external_dns          = "v0.11.0"
  argo_cd               = "7.8.10"
  argo_cd_image_updater = "0.12.0"
  alb_controller        = "1.11.0"
}

eks = {
  cluster_version = "1.31"
  eks_nodegroups  = [
    {
      name           = "si-ondemand"
      is_spot        = false
      min_size       = 1
      max_size       = 2
      desired_size   = 1
      volume_size    = 50
      instance_types = ["t3.small"]
      ami_type       = "AL2_x86_64"
    },
    {
      name          = "si-spot"
      is_spot      = true
      min_size     = 1
      max_size     = 2
      desired_size = 1
      instance_types = ["t3.medium"] #, "t3.small"]
    }
  ]
}

common_tags = {
  Project = "simplesurance"
  Env     = "hometask"
  Owner   = "kisialeu"
}
