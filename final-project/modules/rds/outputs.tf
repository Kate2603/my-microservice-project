output "db_endpoint" {
  value = var.use_aurora ? aws_rds_cluster.this[0].endpoint : aws_db_instance.this[0].address
}

output "db_port" {
  value = var.use_aurora ? aws_rds_cluster.this[0].port : aws_db_instance.this[0].port
}

output "db_security_group_id" {
  value = aws_security_group.db.id
}
