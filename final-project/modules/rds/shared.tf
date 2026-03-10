resource "aws_db_subnet_group" "this" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.private_subnets

  tags = merge(var.tags, {
    Name = "${var.project_name}-db-subnet-group"
  })
}

resource "aws_security_group" "db" {
  name        = "${var.project_name}-db-sg"
  description = "Security group for database"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = var.allowed_security_groups
    description     = "Allow PostgreSQL from EKS cluster"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-db-sg"
  })
}
