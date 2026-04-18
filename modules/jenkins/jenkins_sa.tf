# Service account for Jenkins Kubernetes agents (Kaniko) — IRSA for ECR push/pull.
resource "aws_iam_role" "jenkins_sa" {
  name = "${var.cluster_name}-jenkins-sa-ecr"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = var.oidc_provider_arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${var.oidc_provider_url}:sub" = "system:serviceaccount:jenkins:jenkins-sa"
          "${var.oidc_provider_url}:aud" = "sts.amazonaws.com"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "jenkins_sa_ecr" {
  role       = aws_iam_role.jenkins_sa.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "kubernetes_service_account_v1" "jenkins_sa" {
  metadata {
    name      = "jenkins-sa"
    namespace = helm_release.jenkins.namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.jenkins_sa.arn
    }
  }

  depends_on = [helm_release.jenkins]
}
