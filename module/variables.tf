variable "function_name" {
  type        = string
  default     = "basicAuth"
  description = "Lambda function name"
}

variable "basic_auth_credentials" {
  type        = map
  description = "Credentials for Basic Authentication. Pass a map composed of 'user' and 'password'."
}
