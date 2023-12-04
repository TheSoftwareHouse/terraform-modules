output "policies_arns" {
  value = { for k, acc in aws_organizations_policy.this : k => acc.arn }
}