resource "aws_ssm_parameter" "oidc_provider" {
  name        = "/${var.project_prefix}/${var.environment}/eks/oidc-provider"
  description = "The OpenID Connect identity provider."
  type        = "String"
  value       = module.eks.oidc_provider
  tags = merge(
    var.common_tags,
    {
      Environment = var.environment
    }
  )
}

resource "aws_ssm_parameter" "cluster_name" {
  name        = "/${var.project_prefix}/${var.environment}/eks/cluster-name"
  description = "The name of the EKS cluster. Will block on cluster creation until the cluster is really ready."
  type        = "String"
  value       = module.eks.cluster_name
  tags = merge(
    var.common_tags,
    {
      Environment = var.environment
    }
  )
}

resource "aws_ssm_parameter" "oidc_provider_arn" {
  name        = "/${var.project_prefix}/${var.environment}/eks/oidc-provider-arn"
  description = "The ARN of the OIDC Provider."
  type        = "String"
  value       = module.eks.oidc_provider_arn
  tags = merge(
    var.common_tags,
    {
      Environment = var.environment
    }
  )
}
