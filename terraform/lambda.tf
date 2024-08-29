resource "aws_lambda_function" "amm_service" {
  function_name = var.service_name
  image_uri     = "${data.aws_ecr_repository.amm-ecr-repo.repository_url}:latest"
  package_type  = "Image"
  role          = aws_iam_role.lambda.arn
}


resource "aws_lambda_permission" "api_gateway_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.amm_service.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.amm_api_gateway.execution_arn}/*/*"

  depends_on = [
    aws_iam_role.lambda
  ]
}