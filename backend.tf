terraform {
  required_version = ">= 1.10.0"

  backend "s3" {
    bucket       = "goit-devops-hw-tfstate-001001"
    key          = "goit-devops-hw/terraform.tfstate"
    region       = "eu-north-1"
    encrypt      = true
    use_lockfile = true
  }
}
