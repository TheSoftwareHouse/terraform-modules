output "permission_set_arns" {
  value       = merge({ for i in aws_ssoadmin_permission_set.predefined : i.name => i.arn }, { for i in aws_ssoadmin_permission_set.custom : i.name => i.arn })
  description = "A map of permission set ARNs."
}