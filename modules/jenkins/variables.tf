variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "chart_version" {
  description = "Jenkins Helm chart version (lesson default)"
  type        = string
  default     = "5.0.16"
}
