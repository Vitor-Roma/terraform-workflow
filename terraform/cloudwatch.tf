resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.service_name}"
  retention_in_days = 90
}

resource "aws_cloudwatch_log_group" "apigateway" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.amm_api_gateway.id}/prod"
  retention_in_days = 90
}