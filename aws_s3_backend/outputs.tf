output "bucket_arns" {
  value = { for backend, bucket in module.s3_bucket : backend => bucket.s3_bucket_arn }
}

output "dynamodb_table_arns" {
  value = { for backend, dynamodb_table in module.dynamodb_table : backend => dynamodb_table.dynamodb_table_arn }
}


# Temp
output "backends" {
  value = local.backends
}

output "s3_bucket_policies" {
  value = local.s3_bucket_policies
}

output "iam_role_policies" {
  value = local.iam_role_policies
}