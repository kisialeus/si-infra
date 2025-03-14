#module "cluster_autoscaler_irsa_role" {
#  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
#  version = "~> 5.5.0"
#
#  role_name                        = "${var.project_prefix}-${var.environment}-cluster-autoscaler-irsa-role"
#  attach_cluster_autoscaler_policy = true
#  cluster_autoscaler_cluster_ids   = [module.eks.cluster_id]
#
#  oidc_providers = {
#    ex = {
#      provider_arn               = module.eks.oidc_provider_arn
#      namespace_service_accounts = ["kube-system:cluster-autoscaler"]
#    }
#  }
#
#}

module "external_dns_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                     = "${var.project_prefix}-${var.environment}-external-dns-irsa-role"
  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = ["arn:aws:route53:::hostedzone/*"]

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:external-dns"]
    }
  }


  tags = {
    Environment = "eks-cluster"
  }

}

module "ebs_csi_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name             = "${var.project_prefix}-${var.environment}-ebs-csi-irsa-role"
  attach_ebs_csi_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }

}

module "cloudwatch_fluentbit_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name = "${var.project_prefix}-${var.environment}-cloudwatch-fluentbit-irsa-role"

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["logging:fluent-bit"]
    }
  }

}

resource "aws_iam_role_policy" "cloudwatch_fluentbit_policy" {
  name = "AmazonEKS_Cloudwatch_Fluentbit_Policy"
  role = module.cloudwatch_fluentbit_irsa_role.iam_role_name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "cloudwatch:PutMetricData",
              "ec2:DescribeVolumes",
              "ec2:DescribeTags"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "logs:PutLogEvents",
            "Resource": "arn:aws:logs:${var.aws_region}:${local.account_id}:log-group:*:log-stream:*"
        },
        {
            "Effect": "Allow",
            "Action": [
              "logs:CreateLogStream",
              "logs:CreateLogGroup",
              "logs:PutRetentionPolicy",
              "logs:DescribeLogStreams",
              "logs:DescribeLogGroups"
            ],
            "Resource": "arn:aws:logs:${var.aws_region}:${local.account_id}:log-group:*"
        }
    ]
}
EOF
}

module "argocd_image_updater_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name = "${var.project_prefix}-${var.environment}-argocd-image-updater-irsa-role"

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["argocd:argocd-image-updater"]
    }
  }

}

resource "aws_iam_role_policy" "argocd_image_updater_policy" {
  name = "AmazonEKS_Image_Updater_Policy"
  role = module.argocd_image_updater_irsa_role.iam_role_name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "ecr:ListTagsForResource",
        "ecr:ListImages",
        "ecr:GetRepositoryPolicy",
        "ecr:GetLifecyclePolicyPreview",
        "ecr:GetLifecyclePolicy",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetAuthorizationToken",
        "ecr:DescribeRepositories",
        "ecr:DescribeImages",
        "ecr:DescribeImageScanFindings",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability"
      ],
      "Resource": "*"
    }
  ]
}

EOF
}

module "aws_load_balancer_controller_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name = "${var.project_prefix}-${var.environment}-aws-load-balancer-controller"

  attach_load_balancer_controller_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

resource "aws_iam_role_policy" "aws_load_balancer_controller_policy" {
  name = "AmazonEKS_ALB_Controller_Policy"
  role = module.aws_load_balancer_controller_irsa_role.iam_role_name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeSubnets",
        "ec2:DescribeVpcs",
        "ec2:DescribeSecurityGroups",
        "elasticloadbalancing:DescribeLoadBalancers",
        "elasticloadbalancing:DescribeTags"
      ],
      "Resource": "*"
    }
  ]
}

EOF
}
