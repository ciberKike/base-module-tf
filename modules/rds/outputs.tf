output "mysql_host" {
  description = "Mysql endpoint"
  value = aws_db_instance.mysql.address
}