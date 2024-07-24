provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "meu-bucket-terraform"
    key            = "caminho/para/meu/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "audit-log"
  }
}