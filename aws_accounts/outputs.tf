output "accounts_ids" {
  value = { for k, acc in aws_organizations_account.this : k => acc.id }
}
