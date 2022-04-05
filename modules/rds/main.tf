data "aws_secretsmanager_secret" "password" {
  arn = var.secretsmanager_secret_password_arn
}

data "aws_secretsmanager_secret_version" "password_version" {
  secret_id = data.aws_secretsmanager_secret.password.id
}

data "aws_kms_key" "rds-managed-key-by-aws" {
  key_id = "alias/aws/rds"
}


resource "aws_iam_role" "cloudwatch_role" {
  name = format("rds_ecs_instance_role_%s", var.environment_name)
  tags = merge(var.tags_rds)
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "monitoring.rds.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
   ]
  })
}

resource "aws_iam_role_policy_attachment" "cloudwatch_policy-attach" {
  role = aws_iam_role.cloudwatch_role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

resource "aws_db_subnet_group" "private" {
  name       = "db_gartner_tf_${var.environment_name}"
  subnet_ids = var.private_subnet_group
  tags = {
    Name = "DB subnet group"
  }
}


resource "aws_security_group" "mysql" {
  name = "mysql"
  description = "RDS mysql server (terraform-managed)"
  vpc_id = var.vpc_id

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "sg_mysql_rule1"{
    type = "ingress"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_group_id = aws_security_group.mysql.id
    cidr_blocks = var.private_subnets_cdir
    description = "Allow access from private cluster"
}


resource "aws_db_instance" "mysql" {
  depends_on = [ aws_db_subnet_group.private, aws_security_group.mysql, aws_iam_role.cloudwatch_role ]
  
  engine                   = "mysql"
  engine_version           = "8.0.21"
  identifier               = var.identifier_db
  instance_class           = "db.t3.micro"
  
  multi_az                 = true
  db_subnet_group_name     = aws_db_subnet_group.private.name
  vpc_security_group_ids   = [aws_security_group.mysql.id]
  port                     = 3306

  username                 = var.username_db
  password                 = data.aws_secretsmanager_secret_version.password_version.secret_string
  
  publicly_accessible      = false
  storage_encrypted        = true
  kms_key_id               = data.aws_kms_key.rds-managed-key-by-aws.arn
  storage_type             = "gp2"
  allocated_storage        = 5 # gigabytes
  backup_retention_period  = 1   # in days
  delete_automated_backups = false
  skip_final_snapshot      = true

  monitoring_interval      = 30
  monitoring_role_arn      = aws_iam_role.cloudwatch_role.arn

  enabled_cloudwatch_logs_exports = ["general", "error", "audit", "slowquery"]
}