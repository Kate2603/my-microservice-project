resource "aws_rds_cluster" "this" {
  count = var.use_aurora ? 1 : 0

  cluster_identifier      = "${var.project_name}-aurora"
  engine                  = var.aurora_engine
  engine_version          = "16.13"
  database_name           = var.db_name
  master_username         = var.db_username
  master_password         = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [aws_security_group.db.id]
  skip_final_snapshot     = true
  storage_encrypted       = true
  backup_retention_period = 7

  tags = merge(var.tags, {
    Name = "${var.project_name}-aurora"
  })
}

resource "aws_rds_cluster_instance" "this" {
  count = var.use_aurora ? 1 : 0

  identifier          = "${var.project_name}-aurora-instance-1"
  cluster_identifier  = aws_rds_cluster.this[0].id
  instance_class      = var.aurora_instance_class
  engine              = aws_rds_cluster.this[0].engine
  engine_version      = aws_rds_cluster.this[0].engine_version
  publicly_accessible = false

  tags = merge(var.tags, {
    Name = "${var.project_name}-aurora-instance-1"
  })
}
