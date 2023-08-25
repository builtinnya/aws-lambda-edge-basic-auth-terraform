variable "aws_access_key" {
  type        = string
  description = "AWS Access Key"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS Secret Key"
}

variable "region" {
  type        = string
  description = "AWS Region"
}

variable "s3_bucket_name" {
  type        = string
  description = "AWS S3 Bucket name for static web hosting"
}

variable "basic_auth_credentials" {
  type        = map
  description = "Credentials for Basic Authentication. Pass a map composed of 'user' and 'hashed_password'."
}
