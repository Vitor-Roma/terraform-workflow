terraform {
  backend "s3" {
    bucket         = "auto-mate-match-terraform"
    key            = "terraform/terraform.tfstate"
    region         = "us-east-1"
  }
}