variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "amm-lambda"
}

variable "ecr_image_uri" {
  description = "URI of the ECR image"
  type        = string
  default     = "565128601812.dkr.ecr.us-east-1.amazonaws.com/dynamodb-terraform:latest"
}

variable "service_name" {
  description = "Name of the service"
  type        = string
  default     = "amm-service"
}