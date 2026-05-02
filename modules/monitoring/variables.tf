variable "namespace" {
  description = "Kubernetes namespace for Prometheus and Grafana"
  type        = string
  default     = "monitoring"
}

variable "prometheus_release_name" {
  description = "Helm release name for prometheus-community/prometheus"
  type        = string
  default     = "prometheus"
}

variable "grafana_release_name" {
  description = "Helm release name for grafana/grafana"
  type        = string
  default     = "grafana"
}

variable "prometheus_chart_version" {
  description = "prometheus-community/prometheus chart version (empty = latest at install time)"
  type        = string
  default     = ""
}

variable "grafana_chart_version" {
  description = "grafana/grafana chart version (empty = latest at install time)"
  type        = string
  default     = ""
}

variable "grafana_admin_password" {
  description = "Grafana admin password (set via TF_VAR_grafana_admin_password in real envs)"
  type        = string
  sensitive   = true
  default     = "admin123"
}

variable "grafana_admin_secret_name" {
  description = "Kubernetes Secret holding admin-password; default assumes release name \"grafana\" (grafana/grafana chart)"
  type        = string
  default     = "grafana"
}
