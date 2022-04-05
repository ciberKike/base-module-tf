resource "random_password" "master"{
  length           = 16
  special          = true
  override_special = "_!%^"
}

resource "aws_secretsmanager_secret" "password" {
  name = var.sercret_name
  tags = var.tags_secret
}

resource "aws_secretsmanager_secret_version" "password" {
  secret_id = aws_secretsmanager_secret.password.id
  secret_string = random_password.master.result
}

resource "aws_secretsmanager_secret_policy" "secret-policy" {
  secret_arn = aws_secretsmanager_secret.password.arn

  policy =  jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid": "AWSResourcesPolicy",
        "Effect": "Allow",
        "Principal": {
          "Service": "${var.aws_service_name_allow}"
        },
        "Action": "secretsmanager:GetSecretValue",
        "Resource": "${aws_secretsmanager_secret.password.arn}",
        "Condition": {
          "StringEquals": {
            "aws:sourceAccount": "${var.account_id}"
          }
        }
     }
    ]
  })
}