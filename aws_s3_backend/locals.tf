locals {
  account_ids = { for account in data.aws_organizations_organization.this.accounts : account.name => account.id }

  backends = { for backend_key, backend in var.backends : backend_key => {
    account_ids = [for account in backend.account_names : lookup(local.account_ids, account)]
  } }



  s3_bucket_policies = { for backend_key, backend in local.backends : backend_key => templatefile("${path.module}/templates/s3_bucket_policy.tftpl", {
    root_name = backend_key
  }) }

  iam_role_policies = { for backend_key, backend in local.backends : backend_key => templatefile("${path.module}/templates/iam_role_policy.tftpl", {
    account_arns = jsonencode([
      "arn:aws:iam::*:role/aws-reserved/sso.amazonaws.com/*/AWSReservedSSO_AdministratorAccess_*",
      "arn:aws:iam::*:role/BitbucketOIDC_AdministratorAccess"
    ])
    account_ids = jsonencode(backend.account_ids)
  }) }
}