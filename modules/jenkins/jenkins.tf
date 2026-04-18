resource "helm_release" "jenkins" {
  name             = "jenkins"
  namespace        = "jenkins"
  repository       = "https://charts.jenkins.io"
  chart            = "jenkins"
  version          = var.chart_version
  create_namespace = true
  timeout          = 1200

  values = [
    file("${path.module}/values.yaml")
  ]
}
