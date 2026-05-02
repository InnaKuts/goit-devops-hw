output "namespace" {
  description = "Monitoring namespace"
  value       = var.namespace
}

output "prometheus_release_name" {
  value = var.prometheus_release_name
}

output "grafana_release_name" {
  value = var.grafana_release_name
}

output "prometheus_service_name" {
  description = "Prometheus server Service (prometheus-community/prometheus chart)"
  value       = "${var.prometheus_release_name}-server"
}

output "grafana_admin_password_command" {
  description = "Print Grafana admin password from the chart-created Secret"
  value       = "kubectl -n ${var.namespace} get secret ${var.grafana_admin_secret_name} -o jsonpath=\"{.data.admin-password}\" | base64 -d"
}

output "prometheus_port_forward" {
  description = "Port-forward Prometheus UI to http://localhost:9090"
  value       = "kubectl port-forward -n ${var.namespace} svc/${var.prometheus_release_name}-server 9090:80"
}

output "grafana_port_forward" {
  description = "Port-forward Grafana UI to http://localhost:3000"
  value       = "kubectl port-forward -n ${var.namespace} svc/${var.grafana_release_name} 3000:80"
}
