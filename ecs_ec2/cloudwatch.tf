resource "aws_cloudwatch_log_group" "main" {
  name              = "/ecs/${var.project_name}-${var.environment}"
  retention_in_days = 30
  tags              = merge(local.tags, { Name = "${title(var.project_name)} CW Logs" })
}

resource "aws_cloudwatch_log_stream" "main_log_stream" {
  name           = "${var.project_name}-${var.environment}-log-stream"
  log_group_name = aws_cloudwatch_log_group.main.name
}
