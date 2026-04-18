output "argo_cd_namespace" {
  value = var.namespace
}

output "argo_cd_server_service" {
  description = "In-cluster Argo CD server DNS (lesson-style)"
  value       = "${var.name}-server.${var.namespace}.svc.cluster.local"
}

output "argo_cd_admin_password_command" {
  description = "Initial admin password"
  value       = "kubectl -n ${var.namespace} get secret argocd-initial-admin-secret -o jsonpath=\"{.data.password}\" | base64 -d"
}
