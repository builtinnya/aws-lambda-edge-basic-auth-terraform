output "lambda_arn" {
  value       = length(aws_lambda_function.basic_auth[*].qualified_arn) > 0 ? aws_lambda_function.basic_auth[0].qualified_arn : null 
  description = "Lambda function ARN with version"
}
