variable "vpc_id" {
  description = "VPC id for the security group associate to the rds instance"
  type = string
}

variable "environment_name" {
  description = "Environment name"
  type        = string
}

variable "private_subnet_group" {
  description = "List of privates subnets where the rds instance will run"
  type        = list(string)
}

variable "private_subnets_cdir" {
  description = "Subnets cidr for ingress acess to the rds instance"
  type        = list(string)
}

variable "secretsmanager_secret_password_arn" {
    description = "Secret  manager arn for the secret password parameter"
    type        = string
}

variable "username_db" {
    description = "User name db"
    type        = string
}

variable "identifier_db" {
  description = "Identifier name db"
  type        = string
}

variable  "tags_rds" {
  description = "A mapping of tags to assign"
  type        = map(string)
}