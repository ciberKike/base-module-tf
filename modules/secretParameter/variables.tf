variable "sercret_name" {
  description = "The current aws account id"
  type        = string
}

variable "environment_name" {
  description = "Environment name"
  type        = string
}

variable "tags_secret" {
  description = "A mapping of tags to assign"
  type        = map(string)
}

variable "aws_service_name_allow" {
  description = "A list of aws service allow to retrive the secret value"
  type        = list(string)
}

variable  "account_id" {
  description = "The current aws account id"
  type        = string
}