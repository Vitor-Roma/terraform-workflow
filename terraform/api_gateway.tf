resource "aws_api_gateway_rest_api" "amm_api_gateway" {
  name        = "Auto_Mate_Match_Api_Gateway"
  description = "API Gateway for my Lambda function"
}

resource "aws_api_gateway_resource" "amm_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.amm_api_gateway.id
  parent_id   = aws_api_gateway_rest_api.amm_api_gateway.root_resource_id
  path_part   = "{proxy+}"
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
