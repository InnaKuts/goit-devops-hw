terraform {
  required_version = ">= 1.10.0"

  backend "s3" {
    bucket       = "goit-devops-lesson-5-tfstate-001001"
    key          = "lesson-5/terraform.tfstate"
    region       = "eu-north-1"
    encrypt      = true
    use_lockfile = true
  }
}
