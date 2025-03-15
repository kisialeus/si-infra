resource "aws_iam_user" "ecr_user" {
  name = "${var.project_prefix}-ecr-push-user"
}

resource "aws_iam_policy" "ecr_push_policy" {
  name        = "${var.project_prefix}-ECRPushPolicy"
  description = "Allows push and pull access to ECR"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
        Resource = "*"
      }
    ]
  })

}

resource "aws_iam_user_policy_attachment" "ecr_policy_attachment" {
  user       = aws_iam_user.ecr_user.name
  policy_arn = aws_iam_policy.ecr_push_policy.arn
}

resource "aws_iam_access_key" "ecr_user_access_key" {
  user = aws_iam_user.ecr_user.name
}

resource "aws_secretsmanager_secret" "ecr_user_secret" {
  name        = "${var.project_prefix}-ecr-push-user-credentials"
  description = "Access and secret keys for the ECR push user"
  recovery_window_in_days = 0
  tags = var.common_tags
}

resource "aws_secretsmanager_secret_version" "ecr_user_secret_version" {
  secret_id     = aws_secretsmanager_secret.ecr_user_secret.id
  secret_string = jsonencode({
    access_key_id     = aws_iam_access_key.ecr_user_access_key.id
    secret_access_key = aws_iam_access_key.ecr_user_access_key.secret
  })

}
