resource "aws_db_instance" "this" {
  count = var.use_aurora ? 0 : 1

  identifier              = "${var.project_name}-rds"
  allocated_storage       = var.allocated_storage
  db_name                 = var.db_name
  engine                  = var.db_engine
  engine_version          = var.db_engine == "postgres" ? "16.13" : null
  instance_class          = var.db_instance_class
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [aws_security_group.db.id]
  skip_final_snapshot     = true
  publicly_accessible     = false
  storage_encrypted       = true
  backup_retention_period = 7
  multi_az                = false

  tags = merge(var.tags, {
    Name = "${var.project_name}-rds"
  })
}
