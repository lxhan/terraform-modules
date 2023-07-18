resource "aws_launch_template" "main" {
  name_prefix          = "${var.project_name}-${var.environment}-asg-launch-config"
  image_id             = var.ami
  instance_type        = var.instance_type
  security_group_names = [aws.aws_security_group.lb_sg.name]
  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_agent.name
  }
  user_data = "#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.main.name} > /etc/ecs/ecs.config"
  tags      = merge(local.tags, { Name = "${title(var.project_name)} Launch Template" })
}

resource "aws_autoscaling_group" "main" {
  name                      = "${var.project_name}-${var.environment}-asg"
  vpc_zone_identifier       = aws_subnet.public.*.id
  min_size                  = var.app_min_count
  max_size                  = var.app_max_count
  desired_capacity          = var.app_count
  health_check_grace_period = var.health_check_grace_period_seconds
  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }
  tags = merge(local.tags, { Name = "${title(var.project_name)} ASG" })
}

