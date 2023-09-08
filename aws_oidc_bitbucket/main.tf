data "aws_caller_identity" "current" {}

resource "aws_iam_openid_connect_provider" "this" {
  url             = var.identity_provider_url
  client_id_list  = [var.audience]
  thumbprint_list = var.thumbprints

  tags = var.tags
}

module "iam_iam-policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.9.0"

  create_policy = true
  name          = "BitbucketOIDCPolicy"
  description   = "Allows to assume a role by BitbucketOIDC roles."
  path          = "/"
  policy        = local.bitbucket_oidc_policy

  tags = var.tags
}

module "iam_iam-assumable-role-with-oidc" {
  source   = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version  = "5.8.0"
  for_each = local.wildcards

  create_role                  = true
  role_name                    = "Bitbucket_${each.key}_AccessRole" # ^[\w+=,.@-]{1,64}$
  role_description             = "Role that can be assumed using Bitbucket Pipelines with OIDC provider."
  aws_account_id               = data.aws_caller_identity.current.account_id
  provider_url                 = trimprefix(var.identity_provider_url, "https://")
  role_policy_arns             = local.iam_roles[each.key].iam_policy_arns
  oidc_subjects_with_wildcards = each.value

  tags = var.tags
}



