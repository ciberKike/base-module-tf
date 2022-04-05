## This a module to create a secure RDS instance.

The user that will use this module must have a similar policy associate as below.
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ec2:*",
                "kms:*",
                "secretsmanager:*",
                "rds:*",
                "iam:*"
            ],
            "Resource": "*"
        }
    ]
}
```

**IMPORTANT:** This module works with 4 subnets, 2 public and 2 private, it is necessary to set for this variables network_availability_zone_name
and  network_cidr_block, this 4 key: `public1` `public2` `private1` `private2`. At least you must set ` rds.amazonaws.com `. As you can see in the example below.
                
## Example
```hcl
module "base" {
  source = "git@github.com:ciberKike/base-module-tf.git?ref=v0.1.1"
  environment_name = "test"
 
  network_vpc_cdir = "10.30.0.0/16"

  network_availability_zone_name = {
      "public1" = "eu-west-2a"
      "public2" = "eu-west-2b"
      "private1" = "eu-west-2a"
      "private2" = "eu-west-2b"
    }

  network_cidr_block = {
    "public1" = "10.30.0.0/24"
    "public2" = "10.30.1.0/24"
    "private1" = "10.30.2.0/24"
    "private2" = "10.30.3.0/24"
  }

  project_name = "gartner"
 
  secretmanager_secret_name = "rds" 
  secretmanager_rds_aws_service_allow = ["iam.amazonaws.com", "rds.amazonaws.com"]

  rds_username_db = "profile"

}
```

<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform version](#requirement\_terraform) | >= 1.0.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.0 |

## Resources

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|---------|
| <a name="network_vpc_cdir"></a> [network_vpc_cdir](#network_vpc_cdir) | Vpc cidr for the vpc creation. | `string` | yes |
| <a name="network_availability_zone_name"></a> [network_availability_zone_name](#network_availability_zone_name) | Maping of availability zone names for public and private subnets creation. You must set these 4 keys `public1` `public2` `private1` `private2`  | `map(string)` | yes |
| <a name="network_cidr_block"></a> [network_cidr_block](#network_cidr_block) | Maping of the cidr block for publics and privates subnets creation. You must set these 4 keys `public1` `public2` `private1` `private2` | `map(string)` | yes |
| <a name="secretmanager_secret_name"></a> [secretmanager_secret_name](#secretmanager_secret_name) | The secret manager name that will created for the rds password | `string` | yes |
| <a name="secretmanager_rds_aws_service_allow"></a> [secretmanager_rds_aws_service_allow](#secretmanager_rds_aws_service_allow) | A list of aws service allow to retrieve the secret value. At least you must set ` rds.amazonaws.com ` value | ` list(string)` | yes |
| <a name="rds_username_db"></a> [rds_username_db](#rds_username_db) | The user name for the rds instance. | ` string ` | yes |
| <a name="environment_name"></a> [environment_name](#environment_name) | The name of the environment (eg: stage, demo, production). This is concatenated to the created resource names as a suffix. | ` string ` | yes |
| <a name="project_name"></a> [project_name](#project_name) | The project name that will use the mysql database (eg: gartner). | ` string ` | yes |


## Outputs

| Name | Description |
|------|-------------|
| <a name="rds_mysql_host"></a> [mysql_host](#output\mysql_host) | The Mysql endpoint to connect |
<!-- markdownlint-restore -->

If you want to get the rds instance password, you should execute this command

``` aws secretsmanager get-secret-value --secret-id gartner/test/{secretmanager_secret_name} --profile {your profile name} ```