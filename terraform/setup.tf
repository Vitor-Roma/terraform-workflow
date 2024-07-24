resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-bucket-test123"
  acl    = "private"

  versioning {
    enabled = true
  }
}

resource "aws_dynamodb_table" "terraform_lock" {
  name         = "my-lock-dynamodb-table"
  billing_mode = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
