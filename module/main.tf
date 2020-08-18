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

data "template_file" "basic_auth_function" {
  template = "${file("${path.module}/functions/basic-auth.js")}"
  vars = "${var.basic_auth_credentials}"
}

data "archive_file" "basic_auth_function" {
  type = "zip"
  output_path = "${path.module}/functions/basic-auth.zip"

  source {
    content = "${data.template_file.basic_auth_function.rendered}"
    filename = "basic-auth.js"
  }
}

resource "aws_lambda_function" "basic_auth" {
  filename         = "${path.module}/functions/basic-auth.zip"
  function_name    = "${var.function_name}"
  role             = "${aws_iam_role.lambda.arn}"
  handler          = "basic-auth.handler"
  source_code_hash = "${data.archive_file.basic_auth_function.output_base64sha256}"
  runtime          = "nodejs12.x"
  description      = "Protect CloudFront distributions with Basic Authentication"
  publish          = true
}
