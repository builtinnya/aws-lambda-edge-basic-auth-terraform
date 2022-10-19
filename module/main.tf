###
# IAM Roles
#

# We have to create and use an IAM role that can be assumed by the two service principals -
# lambda.amazonaws.com and edgelambda.amazonaws.com.
# See: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/lambda-edge-permissions.html
resource "aws_iam_role" "lambda" {
  name_prefix        = "basicAuth-"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  inline_policy {
    name   = "CloudWatchLogsAccess"
    policy = data.aws_iam_policy_document.lambda.json
  }
}

###
# IAM Role Policies
#

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com", "edgelambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:*:*:*",
    ]
  }
}

###
# Lambda functions
#

data "archive_file" "basic_auth_function" {
  type        = "zip"
  output_path = "${path.module}/functions/basic-auth.zip"

  source {
    content  = templatefile("${path.module}/functions/basic-auth.js", var.basic_auth_credentials)
    filename = "basic-auth.js"
  }
}

resource "aws_lambda_function" "basic_auth" {
  count            = var.create ? 1 : 0
  filename         = "${path.module}/functions/basic-auth.zip"
  function_name    = var.function_name
  role             = aws_iam_role.lambda.arn
  handler          = "basic-auth.handler"
  source_code_hash = data.archive_file.basic_auth_function.output_base64sha256
  runtime          = "nodejs16.x"
  description      = "Protect CloudFront distributions with Basic Authentication"
  publish          = true
}
