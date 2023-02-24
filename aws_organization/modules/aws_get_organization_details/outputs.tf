# Organizational Units
output "ou_ids" {
  value       = local.ou_ids
  description = "All levels Organizational Unit IDs."
}

output "root_ids" {
  value       = local.root
  description = ""
}

output "l1_ou_ids" {
  value       = local.level_1
  description = "1st level Organizational Unit IDs."
}

output "l2_ou_ids" {
  value       = local.level_2
  description = "2nd level Organizational Unit IDs."
}

output "l3_ou_ids" {
  value       = local.level_3
  description = "3rd level Organizational Unit IDs."
}

output "l4_ou_ids" {
  value       = local.level_4
  description = "4th level Organizational Unit IDs."
}

output "l5_ou_ids" {
  value       = local.level_5
  description = "5th level Organizational Unit IDs."
}

# Accounts
output "account_ids" {
  value       = local.account_ids
  description = "All account IDs."
}