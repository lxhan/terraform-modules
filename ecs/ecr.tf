resource "aws_ecr_repository" "main" {
  name = "${var.project_name}-repo"
  tags = merge(local.tags, { Name = "${title(var.project_name)} ECR" })
}
