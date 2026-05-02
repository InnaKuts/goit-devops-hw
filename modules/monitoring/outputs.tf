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

output "prometheus_port_forward" {
  description = "Port-forward Prometheus UI (opens http://localhost:9090)"
  value       = "kubectl port-forward -n ${var.namespace} svc/${var.name}-kube-prometheus-prometheus 9090:9090"
}

output "grafana_port_forward" {
  description = "Port-forward Grafana (opens http://localhost:3000; default admin password in values.yaml)"
  value       = "kubectl port-forward -n ${var.namespace} svc/${var.name}-grafana 3000:80"
}
