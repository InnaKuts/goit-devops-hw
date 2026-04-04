provider "aws" {
  region = "eu-north-1"
}

module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "goit-devops-lesson-5-tfstate-001001"
  table_name  = "terraform-locks"
}
