resource "aws_security_group" "lb_sg" {
  name        = "${var.project_name}-lb-sg"
  description = "Security group for ALB"
  vpc_id      = var.create_vpc ? aws_vpc.main[0].id : var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = var.app_port
    to_port     = var.app_port
    cidr_blocks = [var.allow_all_cidr]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = [var.allow_all_cidr]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = [var.allow_all_cidr]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 8443
    to_port     = 8443
    cidr_blocks = [var.allow_all_cidr]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = [var.allow_all_cidr]
  }
  tags = merge(local.tags, { Name = "${title(var.project_name)} Security Group" })
}

resource "aws_security_group" "ecs_sg" {
  name        = "${var.project_name}-ecs-sg"
  description = "Allows inbound traffic from ALB"
  vpc_id      = var.create_vpc ? aws_vpc.main[0].id : var.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = var.app_port
    to_port         = var.app_port
    security_groups = [aws_security_group.lb_sg.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = [var.allow_all_cidr]
  }

  tags = merge(local.tags, { Name = "${title(var.project_name)} Security Group" })
}

resource "aws_security_group" "rds_sg" {
  count       = var.create_db ? 1 : 0
  name        = "${var.project_name}-rds-sg"
  description = "Security group for RDS"
  vpc_id      = var.create_vpc ? aws_vpc.main[0].id : var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 5432
    to_port     = 5432
    cidr_blocks = [var.allow_all_cidr]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = [var.allow_all_cidr]
  }

  tags = merge(local.tags, { Name = "${title(var.project_name)} RDS Security Group" })
}

resource "aws_security_group" "efs_sg" {
  count       = var.create_efs ? 1 : 0
  name        = "${var.project_name}-efs-sg"
  description = "Security group for EFS"
  vpc_id      = var.create_vpc ? aws_vpc.main[0].id : var.vpc_id

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = [var.allow_all_cidr]
  }

  tags = merge(local.tags, { Name = "${title(var.project_name)} EFS Security Group" })
}

resource "aws_security_group_rule" "efs_ingress_from_ecs" {
  count                    = var.create_efs ? 1 : 0
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ecs_sg.id
  security_group_id        = aws_security_group.efs_sg[0].id
}

resource "aws_security_group_rule" "ecs_egress_to_efs" {
  count                    = var.create_efs ? 1 : 0
  type                     = "egress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.efs_sg[0].id
  security_group_id        = aws_security_group.ecs_sg.id
}
