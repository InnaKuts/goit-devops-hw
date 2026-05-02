resource "helm_release" "monitoring" {
  name             = var.name
  namespace        = var.namespace
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = var.chart_version
  create_namespace = true
  timeout          = 1800

  values = [
    file("${path.module}/values.yaml")
  ]
}
