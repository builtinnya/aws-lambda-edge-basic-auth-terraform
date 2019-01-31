output "lambda_arn" {
  value       = "${aws_lambda_function.basic_auth.qualified_arn}"
  description = "Lambda function ARN with version"
}
