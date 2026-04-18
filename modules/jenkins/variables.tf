variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "oidc_provider_arn" {
  description = "EKS OIDC provider ARN (for Jenkins agent IRSA / Kaniko ECR push)"
  type        = string
}

variable "oidc_provider_url" {
  description = "EKS OIDC issuer host without https:// (for IAM trust condition)"
  type        = string
}

variable "chart_version" {
  description = "Jenkins Helm chart version (lesson default)"
  type        = string
  default     = "5.0.16"
}
