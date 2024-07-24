data "aws_iam_policy_document" "dynamodb_put_item_policy_document" {
  statement {
    actions   = ["dynamodb:PutItem"]
    resources = [aws_dynamodb_table.audit-log-sdk-dynamodb-table.arn]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "dynamodb_put_item_policy" {
  name        = "dynamodb-put-item-policy"
  description = "IAM policy to allow inserting items into a specific DynamoDB table"
  policy      = data.aws_iam_policy_document.dynamodb_put_item_policy_document.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    effect = "Allow"
  }
}

resource "aws_iam_role" "dynamodb_put_item_role" {
  name = "dynamodb_put_item_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  policy_arn = aws_iam_policy.dynamodb_put_item_policy.arn
  role       = aws_iam_role.dynamodb_put_item_role.name
}
