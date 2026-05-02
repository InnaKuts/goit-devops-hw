variable "name" {
  description = "Helm release name for monitoring stack"
  type        = string
  default     = "monitoring"
}

variable "namespace" {
  description = "Kubernetes namespace for Prometheus/Grafana"
  type        = string
  default     = "monitoring"
}

variable "chart_version" {
  description = "kube-prometheus-stack chart version"
  type        = string
  default     = "58.5.1"
}
