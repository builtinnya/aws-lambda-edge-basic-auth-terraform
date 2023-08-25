variable "function_name" {
  type        = string
  default     = "basicAuth"
  description = "Lambda function name"
}

variable "basic_auth_hashed_username" {
  type        = string
  description = "Basic auth hashed username"
}

variable "basic_auth_hashed_password" {
  type        = string
  description = "Basic auth hashed password"
}
