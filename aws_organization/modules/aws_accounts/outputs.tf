output "account_ids" {
  value = { for name, account in aws_organizations_account.this : name => account.id }
}