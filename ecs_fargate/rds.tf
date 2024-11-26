resource "aws_db_instance" "main" {
  count                       = var.create_db ? 1 : 0
  identifier                  = "${var.project_name}-${var.environment}-db"
  allocated_storage           = var.db_storage
  max_allocated_storage       = 1000
  storage_type                = "gp3"
  db_name                     = var.db_name
  engine                      = var.db_engine
  engine_version              = var.db_engine_version
  instance_class              = var.db_instance_class
  username                    = var.db_username
  password                    = var.db_password
  parameter_group_name        = "default.${var.db_engine}${var.db_engine_version}"
  skip_final_snapshot         = true
  manage_master_user_password = true
  multi_az                    = false
  publicly_accessible         = true

  tags = merge(local.tags, { Name = "${title(var.project_name)} RDS" })
}
