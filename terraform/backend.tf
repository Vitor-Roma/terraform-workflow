terraform {
  backend "s3" {
    bucket         = "bucket-irating"
    key            = "terraform/terraform.tfstate"
    region         = "us-east-1"
  }
}