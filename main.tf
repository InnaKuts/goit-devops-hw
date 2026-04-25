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

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
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

  node_desired_size = 10
  node_min_size     = 2
  node_max_size     = 14

  depends_on = [module.vpc]
}

# module "jenkins" {
#   source = "./modules/jenkins"

#   cluster_name        = module.eks.cluster_name
#   oidc_provider_arn   = module.eks.oidc_provider_arn
#   oidc_provider_url   = module.eks.oidc_provider_url

#   providers = {
#     helm       = helm
#     kubernetes = kubernetes
#   }

#   depends_on = [module.eks]
# }

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

module "rds" {
  source = "./modules/rds"

  name                          = "goit-devops-hw-db"
  use_aurora                    = var.rds_use_aurora
  engine                        = "postgres"
  engine_version                = "17.2"
  instance_class                = "db.t3.micro"
  allocated_storage             = 20
  db_name                       = var.rds_db_name
  username                      = var.rds_username
  password                      = var.rds_master_password
  vpc_id                        = module.vpc.vpc_id
  subnet_private_ids            = module.vpc.private_subnet_ids
  subnet_public_ids             = module.vpc.public_subnet_ids
  publicly_accessible           = false
  multi_az                      = false
  aurora_replica_count          = 1
  parameter_group_family_rds    = "postgres17"
  engine_cluster                = "aurora-postgresql"
  engine_version_cluster        = "15.3"
  parameter_group_family_aurora = "aurora-postgresql15"

  tags = {
    Environment = "dev"
    Project     = "goit-devops-hw"
  }

  depends_on = [module.vpc]
}
