output "iam_role_arns" {
  value       = { for k, v in module.iam_iam-assumable-role-with-oidc : k => v.iam_role_arn }
  description = "Returns OIDC IAM role ARNs."
}