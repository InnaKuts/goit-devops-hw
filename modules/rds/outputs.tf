output "db_subnet_group_name" {
  description = "DB subnet group name"
  value       = aws_db_subnet_group.default.name
}

output "security_group_id" {
  description = "Security group ID for the database"
  value       = aws_security_group.rds.id
}

output "standard_endpoint" {
  description = "Connection endpoint for standard RDS (empty if Aurora is used)"
  value       = var.use_aurora ? null : aws_db_instance.standard[0].address
}

output "standard_port" {
  description = "Port for standard RDS (empty if Aurora is used)"
  value       = var.use_aurora ? null : aws_db_instance.standard[0].port
}

output "standard_identifier" {
  description = "RDS instance identifier (empty if Aurora is used)"
  value       = var.use_aurora ? null : aws_db_instance.standard[0].identifier
}

output "aurora_cluster_endpoint" {
  description = "Writer endpoint for Aurora (empty if standard RDS is used)"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].endpoint : null
}

output "aurora_reader_endpoint" {
  description = "Reader endpoint for Aurora (empty if standard RDS is used)"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].reader_endpoint : null
}

output "aurora_port" {
  description = "Port for Aurora (empty if standard RDS is used)"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].port : null
}

output "aurora_cluster_identifier" {
  description = "Aurora cluster identifier (empty if standard RDS is used)"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].cluster_identifier : null
}
