 
data "aws_caller_identity" "current" {}

#####################
# vpc module        #
#####################

module "vpc" {
  source                  = "./modules/vpc"

  vpc_cdir = var.network_vpc_cdir
  cidr_block = var.network_cidr_block
  availability_zone_name = var.network_availability_zone_name
  
  sufix_name_resource = format("%s-%s", var.project_name, var.environment_name)

  tags_network = {
    project = format("%s-%s", var.project_name, var.environment_name)
    group = format("%s-terraform-%s", var.project_name , var.environment_name)
  }
}


##########################
# secret manager module  #
##########################

module "secretParameter" {
     source         = "./modules/secretParameter"

     sercret_name = format("%s/%s/%s", var.project_name, var.environment_name, var.secretmanager_secret_name)
     aws_service_name_allow = var.secretmanager_rds_aws_service_allow
     environment_name = var.environment_name

     account_id = data.aws_caller_identity.current.account_id

     tags_secret = {
      project = format("%s-%s", var.project_name, var.environment_name)
      group = format("%s-terraform-%s", var.project_name , var.environment_name)
  }
 
}

#####################
# rds module        #
#####################

module "rds" {
    depends_on = [module.vpc, module.secretParameter]
    source         = "./modules/rds"
 
    identifier_db = "gartner-${var.environment_name}"
    environment_name = var.environment_name

    vpc_id = module.vpc.vpc_id 
    private_subnet_group = module.vpc.private_subnets_id
    private_subnets_cdir = [var.network_cidr_block["private1"], var.network_cidr_block["private2"]]

    secretsmanager_secret_password_arn = module.secretParameter.secret_arn
    username_db = var.rds_username_db
    
    tags_rds = {
      project = format("%s-%s", var.project_name, var.environment_name)
      group = format("%s-terraform-%s", var.project_name , var.environment_name)
  }
}