
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0.0"

  cluster_name    = "${var.project_prefix}-${var.environment}-cluster"
  cluster_version = var.cluster_version
  enable_cluster_creator_admin_permissions = true
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  cluster_ip_family = "ipv4"
  cluster_service_ipv4_cidr = "10.100.0.0/16"

  create_cloudwatch_log_group = true
  cloudwatch_log_group_retention_in_days = 30

  cluster_addons = {
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}

    eks-pod-identity-agent = {}

    aws-ebs-csi-driver = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  # VPC setup
  vpc_id                   = var.vpc_id
  subnet_ids               = var.private_subnets
  control_plane_subnet_ids = var.public_subnets


  tags = merge(
    var.common_tags,
    {
      Environment = "eks-cluster"

    }
  )

  # defautl node groups
  eks_managed_node_group_defaults = {
    instance_types = ["t3a.medium", "t3.medium"]

    security_group_rules = {
        outAll = {
          description = ""
          protocol    = "-1"
          from_port   = 0
          to_port     = 0
          type        = "egress"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }
  }


  eks_managed_node_groups = var.eks_nodegroups != null ? local.eks_nodegroups : {}

}
