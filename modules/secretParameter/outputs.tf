output "secret_arn" {
    description = "Arn of the secret created"
    value = aws_secretsmanager_secret.password.arn
}