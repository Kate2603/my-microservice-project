resource "aws_db_instance" "this" {
  count = var.use_aurora ? 0 : 1

  identifier = var.identifier

  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type
  storage_encrypted = var.storage_encrypted

  db_name  = var.db_name
  username = var.master_username
  password = var.master_password
  port     = var.port

  multi_az = var.multi_az

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.this.id]
  parameter_group_name   = aws_db_parameter_group.instance[0].name

  publicly_accessible     = var.publicly_accessible
  backup_retention_period = var.backup_retention_period
  deletion_protection     = var.deletion_protection
  skip_final_snapshot     = var.skip_final_snapshot
  apply_immediately       = var.apply_immediately

  tags = merge(local.common_tags, {
    Name = var.identifier
    Type = "rds-instance"
  })
}