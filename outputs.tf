output "s3_bucket_url" {
  description = "URL of the S3 bucket for Terraform state"
  value       = module.s3_backend.s3_bucket_url
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = module.vpc.private_subnet_ids
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = module.vpc.internet_gateway_id
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = module.vpc.nat_gateway_id
}

output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = module.ecr.repository_url
}

output "eks_cluster_name" {
  description = "EKS cluster name (for aws eks update-kubeconfig)"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "Kubernetes API server endpoint"
  value       = module.eks.cluster_endpoint
}

output "eks_configure_kubeconfig" {
  description = "Example command to merge kubeconfig for this cluster"
  value       = "aws eks update-kubeconfig --region eu-north-1 --name ${module.eks.cluster_name}"
}

output "eks_oidc_provider_arn" {
  description = "EKS OIDC provider ARN (for future IRSA roles, e.g. Jenkins Kaniko)"
  value       = module.eks.oidc_provider_arn
}

output "eks_ebs_csi_addon_version" {
  description = "aws-ebs-csi-driver EKS addon version"
  value       = module.eks.ebs_csi_addon_version
}

# output "jenkins_release" {
#   description = "Helm release name for Jenkins"
#   value       = module.jenkins.jenkins_release_name
# }

# output "jenkins_namespace" {
#   description = "Kubernetes namespace for Jenkins"
#   value       = module.jenkins.jenkins_namespace
# }

output "argo_cd_namespace" {
  description = "Kubernetes namespace for Argo CD"
  value       = module.argo_cd.argo_cd_namespace
}

output "argo_cd_admin_password_command" {
  description = "Print initial Argo CD admin password"
  value       = module.argo_cd.argo_cd_admin_password_command
}

output "rds_standard_endpoint" {
  description = "PostgreSQL endpoint when use_aurora is false"
  value       = module.rds.standard_endpoint
}

output "rds_standard_port" {
  description = "Database port when use_aurora is false"
  value       = module.rds.standard_port
}

output "rds_aurora_writer_endpoint" {
  description = "Aurora writer endpoint when use_aurora is true"
  value       = module.rds.aurora_cluster_endpoint
}

output "rds_aurora_reader_endpoint" {
  description = "Aurora reader endpoint when use_aurora is true"
  value       = module.rds.aurora_reader_endpoint
}

output "rds_security_group_id" {
  description = "Security group attached to the database"
  value       = module.rds.security_group_id
}
