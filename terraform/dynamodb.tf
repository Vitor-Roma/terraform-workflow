resource "aws_dynamodb_table" "audit-log-sdk-dynamodb-table" {
  name           = "audit-log"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "id"
  range_key      = "created_at"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "app"
    type = "S"
  }

  attribute {
    name = "resource_id"
    type = "S"
  }


  attribute {
    name = "action"
    type = "S"
  }


  attribute {
    name = "actor"
    type = "S"
  }

  attribute {
    name = "created_at"
    type = "N"
  }

  ttl {
    attribute_name = "ttl"
    enabled        = true
  }

  global_secondary_index {
    name            = "app-created_at-index"
    hash_key        = "app"
    range_key       = "created_at"
    projection_type = "ALL"
    read_capacity   = 20
    write_capacity  = 20
  }

  global_secondary_index {
    name            = "resource_id-created_at-index"
    hash_key        = "resource_id"
    range_key       = "created_at"
    projection_type = "ALL"
    read_capacity   = 20
    write_capacity  = 20
  }

  global_secondary_index {
    name            = "actor-created_at-index"
    hash_key        = "actor"
    range_key       = "created_at"
    projection_type = "ALL"
    read_capacity   = 20
    write_capacity  = 20
  }

  global_secondary_index {
    name            = "action-created_at-index"
    hash_key        = "action"
    range_key       = "created_at"
    projection_type = "ALL"
    read_capacity   = 20
    write_capacity  = 20
  }
}