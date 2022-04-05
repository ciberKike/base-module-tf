output "rds_mysql_host" {
  description = "Mysql endpoint"
  value = module.rds.mysql_host
}