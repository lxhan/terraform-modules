resource "aws_efs_file_system" "main" {
  count          = var.use_efs_volume ? 1 : 0
  creation_token = "${var.project_name}-${var.environment}-efs"

  tags = merge(local.tags, { Name = "${title(var.project_name)} EFS" })
}

resource "aws_efs_backup_policy" "policy" {
  count          = var.use_efs_volume ? 1 : 0
  file_system_id = aws_efs_file_system.main[0].id

  backup_policy {
    status = "ENABLED"
  }
}
