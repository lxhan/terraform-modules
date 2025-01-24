resource "aws_efs_file_system" "main" {
  count                  = var.create_efs ? 1 : 0
  creation_token         = "${var.project_name}-${var.environment}-efs"
  encrypted              = true
  availability_zone_name = var.az_name

  tags = merge(local.tags, { Name = "${title(var.project_name)} EFS" })
}

resource "aws_efs_mount_target" "main" {
  count          = var.create_efs ? 1 : 0
  file_system_id = aws_efs_file_system.main[0].id
  subnet_id      = aws_subnet.private[0].id
}

resource "aws_efs_backup_policy" "policy" {
  count          = var.create_efs ? 1 : 0
  file_system_id = aws_efs_file_system.main[0].id

  backup_policy {
    status = "ENABLED"
  }
}
