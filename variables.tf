variable "gitops_repo_url" {
  description = "Git HTTPS URL for the Argo CD Application (set to your real repo before relying on sync)"
  type        = string
  default     = "https://github.com/InnaKuts/goit-devops-hw.git"
}

variable "gitops_repo_path" {
  description = "Path inside the repo to the Helm chart"
  type        = string
  default     = "charts/django-app"
}

variable "gitops_target_revision" {
  description = "Branch or tag for Argo CD to track"
  type        = string
  default     = "main"
}

variable "rds_master_password" {
  description = "Master password for RDS or Aurora (set in terraform.tfvars or TF_VAR_rds_master_password; never commit secrets)"
  type        = string
  sensitive   = true
}

variable "rds_db_name" {
  description = "Initial database name created on first provision"
  type        = string
  default     = "goitapp"
}

variable "rds_username" {
  description = "Master username for the database"
  type        = string
  default     = "postgres"
}

variable "rds_use_aurora" {
  description = "If true, provision Aurora cluster + writer + readers; if false, a single RDS instance"
  type        = bool
  default     = false
}

variable "grafana_admin_password" {
  description = "Grafana admin password for module.monitoring (override in terraform.tfvars or TF_VAR_grafana_admin_password)"
  type        = string
  sensitive   = true
  default     = "admin123"
}
