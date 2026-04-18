provider "aws" {
  region = "eu-north-1"
}

data "aws_eks_cluster" "this" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "this" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}

provider "helm" {
  kubernetes = {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "goit-devops-hw-tfstate-001001"
}

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
  vpc_name           = "goit-devops-hw-vpc"
}

module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = "goit-devops-hw-ecr"
  scan_on_push = true
}

module "eks" {
  source = "./modules/eks"

  cluster_name       = "goit-devops-hw-eks"
  cluster_version    = "1.31"
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids  = module.vpc.public_subnet_ids

  node_desired_size = 4
  node_min_size     = 2
  node_max_size     = 6

  depends_on = [module.vpc]
}

module "jenkins" {
  source = "./modules/jenkins"

  cluster_name = module.eks.cluster_name

  providers = {
    helm = helm
  }

  depends_on = [module.eks]
}

module "argo_cd" {
  source = "./modules/argo-cd"

  gitops_repo_url        = var.gitops_repo_url
  gitops_repo_path       = var.gitops_repo_path
  gitops_target_revision = var.gitops_target_revision

  providers = {
    helm = helm
  }

  depends_on = [module.eks]
}
