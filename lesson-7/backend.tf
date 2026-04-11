terraform {
  backend "s3" {
    bucket         = "goit-devops-lesson-5-tfstate-001001"
    key            = "lesson-5/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
