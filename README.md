# aws-lambda-edge-basic-auth-terraform

This is a [Terraform](https://www.terraform.io/) module that creates [AWS Lambda@Edge](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/lambda-at-the-edge.html) resources to protect [CloudFront](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Introduction.html) distributions with [Basic Authentication](https://en.wikipedia.org/wiki/Basic_access_authentication).

The purpose of this module is to make it no-brainer to set up AWS resources required to perform Basic Authentication with AWS Lambda@Edge. If you don't want to take care of tedious jobs such as IAM role setup, this is a right module to go with.

The actual code to perform Basic Authentication is derived from [lmakarov/lambda-basic-auth.js](https://gist.github.com/lmakarov/e5984ec16a76548ff2b278c06027f1a4#file-lambda-basic-auth-js).

## Usage

This is a [Terraform module](https://www.terraform.io/docs/modules/index.html). You just need to include the module in one of your Terraform configuration files with some parameters and add [`lambda_function_association` block](https://www.terraform.io/docs/providers/aws/r/cloudfront_distribution.html#lambda-function-association) to your [`aws_cloudfront_distribution` resource](https://www.terraform.io/docs/providers/aws/r/cloudfront_distribution.html). See [examples/](/examples) for complete examples.

```hcl
# If the parent module provider region is not us-east-1, define provider for us-east-1.
#
#provider "aws" {
#  alias  = "us-east-1"
#  region = "us-east-1"
#}

module "basic_auth" {
  source = "github.com/builtinnya/aws-lambda-edge-basic-auth-terraform/module"

  basic_auth_credentials = {
    user     = "your-username"
    password = "your-password"
  }

  # All Lambda@Edge functions must be put on us-east-1.
  # If the parent module provider region is not us-east-1, you have to
  # define and pass us-east-1 provider explicitly.
  # See https://www.terraform.io/docs/modules/usage.html#passing-providers-explicitly for detail.
  #
  #providers = {
  #  aws = "aws.us-east-1"
  #}
}

resource "aws_cloudfront_distribution" "your_distribution" {
  # ...

  # Add the following block to associate the Lambda function.
  lambda_function_association {
    event_type   = "viewer-request"
    lambda_arn   = "${module.basic_auth.lambda_arn}"
    include_body = false
  }
}
```

## Module Inputs and Outputs

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| basic\_auth\_credentials | Credentials for Basic Authentication. Pass a map composed of 'user' and 'password'. | map | n/a | yes |
| function\_name | Lambda function name | string | `"basicAuth"` | no |

## Outputs

| Name | Description |
|------|-------------|
| lambda\_arn | Lambda function ARN with version |

# License

Copyright © 2019 Naoto Yokoyama

Distributed under the MIT license. See the [LICENSE](./LICENSE) file for full details.
