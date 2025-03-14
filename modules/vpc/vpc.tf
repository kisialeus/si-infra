module "cluster_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = "${var.project_prefix}-${var.environment}-vpc"
  cidr = var.vpc_cidr

  azs = slice(data.aws_availability_zones.available.names, 0, var.az_count)


  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  tags = merge(
    var.common_tags,
    {
      Resource = "VPC"
    }
  )
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }


}
