variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where DB resources will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of private subnet IDs for DB subnet group"
  type        = list(string)
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access DB port"
  type        = list(string)
  default     = []
}

variable "use_aurora" {
  description = "If true creates Aurora cluster, otherwise creates standard RDS instance"
  type        = bool
  default     = false
}

variable "engine" {
  description = "Database engine. Examples: postgres, mysql, aurora-postgresql, aurora-mysql"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
  default     = "16.3"
}

variable "instance_class" {
  description = "RDS or Aurora instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "multi_az" {
  description = "Whether to enable Multi-AZ for standard RDS instance"
  type        = bool
  default     = false
}

variable "identifier" {
  description = "DB instance identifier or Aurora cluster identifier"
  type        = string
}

variable "db_name" {
  description = "Initial database name"
  type        = string
  default     = "appdb"
}

variable "master_username" {
  description = "Master username for database"
  type        = string
}

variable "master_password" {
  description = "Master password for database"
  type        = string
  sensitive   = true
}

variable "port" {
  description = "Database port"
  type        = number
  default     = 5432
}

variable "allocated_storage" {
  description = "Allocated storage in GB for standard RDS instance"
  type        = number
  default     = 20
}

variable "storage_type" {
  description = "Storage type for standard RDS instance"
  type        = string
  default     = "gp3"
}

variable "storage_encrypted" {
  description = "Whether storage encryption is enabled"
  type        = bool
  default     = true
}

variable "backup_retention_period" {
  description = "Backup retention period in days"
  type        = number
  default     = 7
}

variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot on destroy"
  type        = bool
  default     = true
}

variable "parameter_group_family" {
  description = "DB parameter group family for standard RDS, for example postgres16 or mysql8.0"
  type        = string
  default     = "postgres16"
}

variable "cluster_parameter_group_family" {
  description = "Cluster parameter group family for Aurora, for example aurora-postgresql16"
  type        = string
  default     = "aurora-postgresql16"
}

variable "db_parameters" {
  description = "List of DB parameters to apply"
  type = list(object({
    name         = string
    value        = string
    apply_method = optional(string, "immediate")
  }))
  default = [
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
}

variable "aurora_instance_count" {
  description = "Number of Aurora instances to create"
  type        = number
  default     = 1
}

variable "publicly_accessible" {
  description = "Whether DB instance should be publicly accessible"
  type        = bool
  default     = false
}

variable "apply_immediately" {
  description = "Whether to apply changes immediately"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}