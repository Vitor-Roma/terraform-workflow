data "aws_ecr_repository" "amm-ecr-repo" {
  name = var.ecr_name
}

output "repository_url" {
  value = data.aws_ecr_repository.amm-ecr-repo.repository_url
}