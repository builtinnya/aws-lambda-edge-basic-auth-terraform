###
# Providers
#

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
}

provider "aws" {
  alias      = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = "us-east-1"
}

###
# Modules
#

module "basic_auth" {
  source                 = "../../module"
  basic_auth_credentials = var.basic_auth_credentials

  # All Lambda@Edge functions must be put on us-east-1.
  providers = {
    aws = "aws.us-east-1"
  }
}

###
# S3
#

resource "aws_s3_bucket" "test" {
  bucket = var.s3_bucket_name
  acl    = "private"

  policy = <<EOF
{
  "Id": "PolicyForCloudFrontPrivateContent",
  "Statement": [
    {
      "Action": "s3:GetObject",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_cloudfront_origin_access_identity.test.iam_arn}"
      },
      "Resource": "arn:aws:s3:::${var.s3_bucket_name}/*",
      "Sid": "Grant a CloudFront Origin Identity access to support private content"
    }
  ],
  "Version": "2012-10-17"
}
EOF
}

resource "aws_s3_bucket_object" "test" {
  bucket       = aws_s3_bucket.test.id
  key          = "index.html"
  source       = "index.html"
  content_type = "text/html"
  etag         = md5(file("index.html"))
}

###
# CloudFront
#

resource "aws_cloudfront_origin_access_identity" "test" {}

resource "aws_cloudfront_distribution" "test" {
  origin {
    domain_name = aws_s3_bucket.test.bucket_regional_domain_name
    origin_id   = "S3-${aws_s3_bucket.test.id}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.test.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "aws-lambda-edge-basic-auth-terraform minimal example"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-${aws_s3_bucket.test.id}"
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }

    lambda_function_association {
      event_type   = "viewer-request"
      lambda_arn   = module.basic_auth.lambda_arn
      include_body = false
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
