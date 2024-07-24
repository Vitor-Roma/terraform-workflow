terraform {
  backend "s3" {
    bucket         = "terraform-bucket-test123"
    key            = "test/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "my-lock-dynamodb-table"
  }
}