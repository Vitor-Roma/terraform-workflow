data "aws_iam_policy_document" "lambda_role" {
  statement {
    effect  = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_cloudwatch_logs" {
  statement {
    effect  = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "${aws_cloudwatch_log_group.lambda.arn}:*"
    ]
  }
}

resource "aws_iam_role" "lambda" {
    name               = var.service_name
    assume_role_policy = data.aws_iam_policy_document.lambda_role.json
}

resource "aws_iam_role_policy_attachment" "allow_lambda_logs" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.allow_lambda_logs.arn
}

resource "aws_iam_role_policy_attachment" "allow_invoke_api" {
  role       = aws_iam_role.lambda.name
  policy_arn = data.aws_iam_policy.allow_invoke_api.arn
}

resource "aws_iam_policy" "allow_lambda_logs" {
  name        = "allow-${aws_lambda_function.amm_service.function_name}-write-cloudwatch-logs"
  description = "Gives ${aws_lambda_function.amm_service.arn} permission to write cloudwatch logs to ${aws_cloudwatch_log_group.lambda.arn}"
  policy      = data.aws_iam_policy_document.lambda_cloudwatch_logs.json
}

data "aws_iam_policy" "allow_invoke_api" {
  name = "api-access"
}
