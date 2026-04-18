output "jenkins_release_name" {
  value = helm_release.jenkins.name
}

output "jenkins_namespace" {
  value = helm_release.jenkins.namespace
}

output "cluster_name" {
  description = "EKS cluster name (passed from root)"
  value       = var.cluster_name
}
