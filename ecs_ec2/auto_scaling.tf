resource "aws_launch_configuration" "main" {
  name                        = "${var.project_name}-${var.environment}-asg-launch-config"
  image_id                    = var.ami
  instance_type               = var.instance_type
  security_groups             = ["${aws_security_group.ecs_sg.id}"]
  iam_instance_profile        = aws_iam_instance_profile.ecs_agent.name
  associate_public_ip_address = true
  user_data                   = "#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.main.name} > /etc/ecs/ecs.config"
}

resource "aws_autoscaling_group" "main" {
  name                      = "${var.project_name}-${var.environment}-asg"
  availability_zones        = var.availability_zones
  launch_configuration      = aws_launch_configuration.main.name
  min_size                  = var.app_min_count
  max_size                  = var.app_max_count
  desired_capacity          = var.app_count
  health_check_grace_period = var.health_check_grace_period_seconds
}

