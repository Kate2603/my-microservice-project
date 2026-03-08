output "db_endpoint" {
  description = "Database endpoint"
  value       = module.rds.endpoint
}

output "db_port" {
  description = "Database port"
  value       = module.rds.port
}

output "db_security_group_id" {
  description = "DB security group ID"
  value       = module.rds.security_group_id
}

output "db_subnet_group_name" {
  description = "DB subnet group name"
  value       = module.rds.db_subnet_group_name
}

output "db_identifier" {
  description = "DB identifier or cluster identifier"
  value       = module.rds.db_identifier
}