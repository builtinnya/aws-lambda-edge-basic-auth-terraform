output "url" {
  value = format("https://%s", "${aws_cloudfront_distribution.test.domain_name}")
}