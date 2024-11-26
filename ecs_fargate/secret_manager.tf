resource "aws_secretsmanager_secret" "main" {
  count = var.create_secret_manager ? 1 : 0
  name  = "${var.environment}/${var.project_name}"
  tags  = merge(local.tags, { Name = "${title(var.project_name)} Secret Manager" })
}
