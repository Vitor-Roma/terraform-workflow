resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "api_gateway_invoke_policy" {
  name   = "api_gateway_invoke_policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = "execute-api:Invoke",
        Effect   = "Allow",
        Resource = "*"
      },
    ],
  })
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

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.api_gateway_invoke_policy.arn
}

resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.amm_service.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn    = "${aws_api_gateway_rest_api.amm_api_gateway.execution_arn}/*${aws_api_gateway_resource.amm_api_resource.path}"
}

resource "aws_iam_policy" "allow_lambda_logs" {
  name        = "allow-${aws_lambda_function.amm_service.function_name}-write-cloudwatch-logs"
  description = "Gives ${aws_lambda_function.amm_service.arn} permission to write cloudwatch logs to ${aws_cloudwatch_log_group.lambda.arn}"
  policy      = data.aws_iam_policy_document.lambda_cloudwatch_logs.json
}