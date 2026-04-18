variable "name" {
  description = "Helm release name for Argo CD"
  type        = string
  default     = "argo-cd"
}

variable "namespace" {
  description = "Kubernetes namespace for Argo CD"
  type        = string
  default     = "argocd"
}

variable "chart_version" {
  description = "argo-cd Helm chart version (lesson default)"
  type        = string
  default     = "5.46.4"
}

variable "gitops_repo_url" {
  description = "Git repository URL for the Application source"
  type        = string
}

variable "gitops_repo_path" {
  description = "Path to the Helm chart in the repository"
  type        = string
}

variable "gitops_target_revision" {
  description = "Branch, tag, or commit to track"
  type        = string
}

variable "application_name" {
  description = "Argo CD Application name"
  type        = string
  default     = "django-app"
}
