#####################
# vpc module        #
#####################

variable "network_vpc_cdir" {
  description = "Vpc cidr for the vpc creation"
  type = string
}

variable "network_availability_zone_name" {
  description = "Maping of availability zone names for public and privates subnet creation"
  type    = map(string)
}

variable "network_cidr_block" {
  description = "Maping of the cidr block for public and private subnets creation"
  type    = map(string)
}


##########################
# secret manager module  #
##########################

variable "secretmanager_rds_aws_service_allow" {
  description = "A list of aws service allow to retrieve the secret value"
  type        = list(string)
}



#####################
# rds module        #
#####################

variable "rds_username_db" {
    description = "RDS user name db"
    type = string
}


#################
# Generic       #
################

variable "environment_name" {
  description = "Environment name"
  type = string
}

variable "project_name" {
  description = "Project name"
  type = string
}
