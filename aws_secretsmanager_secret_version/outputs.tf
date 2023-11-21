output "value" {
  value     = jsondecode(data.aws_secretsmanager_secret_version.this.secret_string)
  sensitive = true
}
