resource "helm_release" "prometheus" {
  name             = var.prometheus_release_name
  namespace        = var.namespace
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "prometheus"
  version          = var.prometheus_chart_version != "" ? var.prometheus_chart_version : null
  create_namespace = true
  timeout          = 1800

  values = [
    file("${path.module}/prometheus-values.yaml")
  ]
}
