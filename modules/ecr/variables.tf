variable "project_prefix" {
  type        = string
  description = "Short name of the project used as a prefix for resources"
}

variable "ecr_repos" {
  type = list(string)
  description = "A list of ECR repos"
}


variable "common_tags" {
  type        = map(string)
  description = "Tags for infrastructure resources."
}
