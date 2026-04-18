output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "Kubernetes API endpoint"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64 CA cert for kubectl"
  value       = aws_eks_cluster.main.certificate_authority[0].data
}

output "cluster_arn" {
  description = "EKS cluster ARN"
  value       = aws_eks_cluster.main.arn
}

output "node_group_name" {
  description = "Managed node group name"
  value       = aws_eks_node_group.main.node_group_name
}

output "oidc_provider_arn" {
  description = "IAM OIDC provider ARN for the cluster (IRSA)"
  value       = aws_iam_openid_connect_provider.eks.arn
}

output "oidc_provider_url" {
  description = "OIDC issuer URL without https:// (useful for IAM condition keys)"
  value       = replace(aws_iam_openid_connect_provider.eks.url, "https://", "")
}

output "ebs_csi_addon_version" {
  description = "Installed aws-ebs-csi-driver addon version"
  value       = aws_eks_addon.ebs_csi_driver.addon_version
}
