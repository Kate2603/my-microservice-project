resource "aws_rds_cluster" "this" {
  count = var.use_aurora ? 1 : 0

  cluster_identifier = var.identifier

  engine         = var.engine
  engine_version = var.engine_version

  database_name   = var.db_name
  master_username = var.master_username
  master_password = var.master_password
  port            = var.port

  db_subnet_group_name            = aws_db_subnet_group.this.name
  vpc_security_group_ids          = [aws_security_group.this.id]
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.cluster[0].name

  backup_retention_period = var.backup_retention_period
  storage_encrypted       = var.storage_encrypted
  deletion_protection     = var.deletion_protection
  skip_final_snapshot     = var.skip_final_snapshot
  apply_immediately       = var.apply_immediately

  tags = merge(local.common_tags, {
    Name = var.identifier
    Type = "aurora-cluster"
  })
}

resource "aws_rds_cluster_instance" "writer" {
  count = var.use_aurora ? var.aurora_instance_count : 0

  identifier         = "${var.identifier}-${count.index + 1}"
  cluster_identifier = aws_rds_cluster.this[0].id
  instance_class     = var.instance_class
  engine             = var.engine
  engine_version     = var.engine_version

  publicly_accessible  = var.publicly_accessible
  db_subnet_group_name = aws_db_subnet_group.this.name

  tags = merge(local.common_tags, {
    Name = "${var.identifier}-${count.index + 1}"
    Type = count.index == 0 ? "aurora-writer" : "aurora-reader"
  })
}