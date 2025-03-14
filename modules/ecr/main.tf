resource "aws_ecr_repository" "ecr" {
  for_each = { for repo in var.ecr_repos : repo => repo }

  name = "${var.project_prefix}/${each.key}"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.common_tags
}
