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
  type        = map(any)
  description = "Credentials for Basic Authentication. Pass a map composed of 'hashed_username' and 'hashed_password'."
}
