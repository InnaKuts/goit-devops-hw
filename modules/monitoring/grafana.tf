resource "helm_release" "grafana" {
  name             = var.grafana_release_name
  namespace        = var.namespace
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  version          = var.grafana_chart_version != "" ? var.grafana_chart_version : null
  create_namespace = true
  timeout          = 1800

  values = [
    templatefile("${path.module}/grafana-values.yaml.tftpl", {
      admin_password  = var.grafana_admin_password
      prometheus_url  = "http://${var.prometheus_release_name}-server.${var.namespace}.svc:80"
    })
  ]

  depends_on = [helm_release.prometheus]
}
