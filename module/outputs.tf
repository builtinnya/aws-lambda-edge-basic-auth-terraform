output "lambda_arn" {
  value       = "${aws_lambda_function.basic_auth.arn}"
  description = "Lambda function ARN"
}
