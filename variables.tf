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
  default     = "lesson-9"
}
