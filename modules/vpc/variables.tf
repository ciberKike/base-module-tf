variable "vpc_cdir" {
  type = string
  description = "Vpc cidr for the vpc creation"
}

variable "availability_zone_name" {
  type    = map(string)
  description = "Maping of availability zone names for publics and privates subnets creation"
}

variable "cidr_block" {
  type    = map
  description = "Maping of the cidr block for publics and privates subnets creation"
}

variable "tags_network" {
  description = "A mapping of tags to assign"
  type        = map(string)
}

variable "sufix_name_resource" {
  description = "A sufix name for each resource"
  type = string
}