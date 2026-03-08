locals {
  name_prefix = "${var.project_name}-${var.environment}"
  common_tags = merge(
    {
      Name        = local.name_prefix
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
    },
    var.tags
  )
}

resource "aws_db_subnet_group" "this" {
  name       = "${local.name_prefix}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-db-subnet-group"
  })
}

resource "aws_security_group" "this" {
  name        = "${local.name_prefix}-db-sg"
  description = "Security group for RDS or Aurora"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow DB access from approved CIDR blocks"
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-db-sg"
  })
}

resource "aws_db_parameter_group" "instance" {
  count = var.use_aurora ? 0 : 1

  name   = "${local.name_prefix}-db-parameter-group"
  family = var.parameter_group_family

  dynamic "parameter" {
    for_each = var.db_parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = try(parameter.value.apply_method, "immediate")
    }
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-db-parameter-group"
  })
}

resource "aws_rds_cluster_parameter_group" "cluster" {
  count = var.use_aurora ? 1 : 0

  name   = "${local.name_prefix}-cluster-parameter-group"
  family = var.cluster_parameter_group_family

  dynamic "parameter" {
    for_each = var.db_parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = try(parameter.value.apply_method, "immediate")
    }
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-cluster-parameter-group"
  })
}