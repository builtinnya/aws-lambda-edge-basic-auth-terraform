variable "function_name" {
  type        = string
  default     = "basicAuth"
  description = "Lambda function name"
}

variable "basic_auth_credentials" {
  type        = map(any)
  description = "Credentials for Basic Authentication. Pass a map composed of 'hashed_username' and 'hashed_password'."
}
