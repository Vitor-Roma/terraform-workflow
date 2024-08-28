variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "service_name" {
  description = "Name of the service"
  type        = string
}

variable "ecr_name" {
  description = "Name of the ECR image"
  type        = string
}