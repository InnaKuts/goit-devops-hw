output "namespace" {
  description = "Monitoring namespace"
  value       = var.namespace
}

output "grafana_service_name" {
  description = "Grafana service name"
  value       = "${var.name}-grafana"
}

output "prometheus_service_name" {
  description = "Prometheus service name"
  value       = "${var.name}-kube-prometheus-prometheus"
}

output "grafana_admin_password_command" {
  description = "Command to print Grafana admin password"
  value       = "kubectl -n ${var.namespace} get secret ${var.name}-grafana -o jsonpath=\"{.data.admin-password}\" | base64 -d"
}
