
output "oidc_provider" {
  description = "The OpenID Connect identity provider"
  value       = module.eks.oidc_provider
}

output "cluster_name" {
  description = "The name of the EKS cluster. Will block on cluster creation until the cluster is really ready"
  value       = module.eks.cluster_name
}

output "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider"
  value       = module.eks.oidc_provider_arn
}

output "cluster_id" {
  description = "EKS cluster ID"
  value = module.eks.cluster_id
}

output "aws_load_balancer_controller_irsa_role" {
  value = module.aws_load_balancer_controller_irsa_role.iam_role_arn
  description = "AWS ALB controller role ARN "
}

output "argocd_image_updater_irsa_role" {
  value = module.argocd_image_updater_irsa_role.iam_role_arn
  description = "ArgoCD image updater role ARN "
}
