module "rds" {
  source = "./modules/rds"

  project_name = var.project_name
  environment  = var.environment

  vpc_id              = var.vpc_id
  subnet_ids          = var.private_subnet_ids
  allowed_cidr_blocks = var.allowed_cidr_blocks

  use_aurora = false

  engine         = "postgres"
  engine_version = "16.13"
  instance_class = "db.t3.micro"
  multi_az       = false

  identifier              = "lesson-db-module-postgres"
  db_name                 = "appdb"
  master_username         = "postgresadmin"
  master_password         = "StrongPassword123!"
  port                    = 5432
  backup_retention_period = 7
  storage_encrypted       = true
  deletion_protection     = false
  skip_final_snapshot     = true

  parameter_group_family         = "postgres16"
  cluster_parameter_group_family = "aurora-postgresql16"

  aurora_instance_count = 1

  db_parameters = [
    {
      name         = "max_connections"
      value        = "100"
      apply_method = "pending-reboot"
    },
    {
      name         = "log_statement"
      value        = "ddl"
      apply_method = "immediate"
    },
    {
      name         = "work_mem"
      value        = "4096"
      apply_method = "immediate"
    }
  ]

  tags = {
    Project     = "lesson-db-module"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}