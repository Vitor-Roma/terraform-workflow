resource "aws_api_gateway_rest_api" "amm_api_gateway" {
  name        = "Auto_Mate_Match_Api_Gateway"
  description = "API Gateway for my Lambda function"
}

resource "aws_api_gateway_resource" "amm_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.amm_api_gateway.id
  parent_id   = aws_api_gateway_rest_api.amm_api_gateway.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_stage" "dsar_service" {
  deployment_id        = aws_api_gateway_deployment.amm_api_deployment.id
  rest_api_id          = aws_api_gateway_rest_api.amm_api_gateway.id
  stage_name           = "prod"
  xray_tracing_enabled = false # TODO: look into setting this to true
  # TODO: look into canary settings

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.amm_service_access.arn
    format          = "$context.identity.sourceIp $context.identity.caller $context.identity.user [$context.requestTime] \"$context.httpMethod $context.resourcePath $context.protocol\" $context.status $context.responseLength $context.requestId $context.extendedRequestId"
  }

  depends_on = [
    aws_cloudwatch_log_group.amm_service_execution,
    aws_cloudwatch_log_group.amm_service_access
  ]
}

resource "aws_api_gateway_method" "amm_api_method" {
  rest_api_id   = aws_api_gateway_rest_api.amm_api_gateway.id
  resource_id   = aws_api_gateway_resource.amm_api_resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.amm_api_gateway.id
  resource_id             = aws_api_gateway_resource.amm_api_resource.id
  http_method             = aws_api_gateway_method.amm_api_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.amm_service.invoke_arn
}

resource "aws_api_gateway_deployment" "amm_api_deployment" {
  depends_on  = [aws_api_gateway_integration.lambda_integration]
  rest_api_id = aws_api_gateway_rest_api.amm_api_gateway.id
  stage_name  = "prod"
}

output "api_gateway_invoke_url" {
  value = "${aws_api_gateway_deployment.amm_api_deployment.invoke_url}/${var.service_name}"
}