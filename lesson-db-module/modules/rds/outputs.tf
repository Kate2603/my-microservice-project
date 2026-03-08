output "endpoint" {
  description = "Database endpoint"
  value       = var.use_aurora ? aws_rds_cluster.this[0].endpoint : aws_db_instance.this[0].address
}

output "reader_endpoint" {
  description = "Aurora reader endpoint or null for standard RDS"
  value       = var.use_aurora ? aws_rds_cluster.this[0].reader_endpoint : null
}

output "port" {
  description = "Database port"
  value       = var.port
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.this.id
}

output "db_subnet_group_name" {
  description = "DB subnet group name"
  value       = aws_db_subnet_group.this.name
}

output "db_identifier" {
  description = "DB identifier or cluster identifier"
  value       = var.use_aurora ? aws_rds_cluster.this[0].cluster_identifier : aws_db_instance.this[0].identifier
}

output "parameter_group_name" {
  description = "Instance parameter group name for standard RDS"
  value       = var.use_aurora ? null : aws_db_parameter_group.instance[0].name
}

output "cluster_parameter_group_name" {
  description = "Cluster parameter group name for Aurora"
  value       = var.use_aurora ? aws_rds_cluster_parameter_group.cluster[0].name : null
}