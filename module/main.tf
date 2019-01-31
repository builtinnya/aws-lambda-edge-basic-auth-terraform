###
# IAM Roles
#

# We have to create and use an IAM role that can be assumed by the two service principals -
# lambda.amazonaws.com and edgelambda.amazonaws.com.
# See: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/lambda-edge-permissions.html
resource "aws_iam_role" "lambda" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com",
          "edgelambda.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

###
# IAM Role Policies
#

resource "aws_iam_role_policy" "lambda" {
  role = "${aws_iam_role.lambda.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    }
  ]
}
EOF
}

###
# Lambda functions
#

resource "aws_lambda_function" "basic_auth" {
  filename         = "${path.module}/functions/lambda-edge-basic-auth-function.zip"
  function_name    = "${var.function_name}"
  role             = "${aws_iam_role.lambda.arn}"
  handler          = "basic-auth.handler"
  source_code_hash = "${base64sha256(file("${path.module}/functions/lambda-edge-basic-auth-function.zip"))}"
  runtime          = "nodejs8.10"
  description      = "Protect CloudFront distributions with Basic Authentication"
}

###
# Secrets
#

resource "aws_secretsmanager_secret" "basic_auth_credentials" {
  name_prefix = "lambda-edge-basic-auth-"
  description = "Secrets for Basic Authentication used by Lambda@Edge"
}

resource "aws_secretsmanager_secret_version" "basic_auth_credentials" {
  secret_id     = "${aws_secretsmanager_secret.basic_auth_credentials.id}"
  secret_string = "${jsonencode(var.basic_auth_credentials)}"
}
