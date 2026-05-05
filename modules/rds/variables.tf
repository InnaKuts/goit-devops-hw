variable "name" {
  description = "Name prefix for RDS instance or Aurora cluster resources"
  type        = string
}

variable "use_aurora" {
  description = "If true, create an Aurora cluster (writer + optional readers); if false, a single RDS instance"
  type        = bool
  default     = false
}

variable "engine" {
  description = "RDS engine for standard RDS (e.g. postgres, mysql)"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "Engine version for standard RDS"
  type        = string
  default     = "17.2"
}

variable "parameter_group_family_rds" {
  description = "DB parameter group family for standard RDS (must match engine major version, e.g. postgres17)"
  type        = string
  default     = "postgres17"
}

variable "engine_cluster" {
  description = "Aurora engine (e.g. aurora-postgresql, aurora-mysql)"
  type        = string
  default     = "aurora-postgresql"
}

variable "engine_version_cluster" {
  description = "Engine version for Aurora cluster"
  type        = string
  default     = "15.3"
}

variable "parameter_group_family_aurora" {
  description = "Cluster parameter group family for Aurora (e.g. aurora-postgresql15)"
  type        = string
  default     = "aurora-postgresql15"
}

variable "aurora_replica_count" {
  description = "Number of Aurora read replicas (writer is always created separately)"
  type        = number
  default     = 1
}

variable "instance_class" {
  description = "DB instance class (e.g. db.t3.micro)"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Allocated storage in GB for standard RDS only"
  type        = number
  default     = 20
}

variable "db_name" {
  description = "Initial database name"
  type        = string
}

variable "username" {
  description = "Master username for the database"
  type        = string
}

variable "password" {
  description = "Master password for the database"
  type        = string
  sensitive   = true
}

variable "vpc_id" {
  description = "VPC ID where the database security group is created"
  type        = string
}

variable "ingress_cidr_blocks" {
  description = "CIDR blocks allowed to reach PostgreSQL on port 5432 (e.g. private subnet CIDRs)"
  type        = list(string)
}

variable "subnet_private_ids" {
  description = "Private subnet IDs used when publicly_accessible is false"
  type        = list(string)
}

variable "subnet_public_ids" {
  description = "Public subnet IDs used when publicly_accessible is true"
  type        = list(string)
}

variable "publicly_accessible" {
  description = "Whether the database is reachable from the internet (uses public subnets when true)"
  type        = bool
  default     = false
}

variable "multi_az" {
  description = "Enable Multi-AZ for standard RDS (ignored for Aurora cluster topology)"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Backup retention in days. Use 0 for AWS Free Tier–eligible RDS (no automated backups). Aurora ignores 0 and uses at least 1 day."
  type        = number
  default     = 0
}

variable "parameters" {
  description = "Engine parameters applied to the DB or cluster parameter group (e.g. max_connections, work_mem)"
  type        = map(string)
  default = {
    max_connections = "200"
    log_statement   = "none"
    work_mem        = "4096"
  }
}

variable "tags" {
  description = "Tags applied to all RDS resources"
  type        = map(string)
  default     = {}
}
