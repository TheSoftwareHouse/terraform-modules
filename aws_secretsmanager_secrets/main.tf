resource "aws_secretsmanager_secret" "this" {
  for_each = toset(var.secrets)
  name     = each.value
  tags     = var.tags
}
