module "iam_iam-assumable-role-with-oidc" {
  source   = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version  = "5.8.0"
  for_each = var.roles

  create_role                    = true
  role_name                      = each.key # ^[\w+=,.@-]{1,64}$
  role_description               = "Role that can be assumed using Bitbucket Pipelines with OIDC provider."
  aws_account_id                 = data.aws_caller_identity.current.account_id
  provider_url                   = trimprefix(var.identity_providers[each.value["provider"]].identity_provider_url, "https://")
  role_policy_arns               = [module.iam_iam-policy.arn]
  oidc_subjects_with_wildcards  = formatlist("%s:*", each.value["repository_uuids"])

  # tags = merge(
  #   local.common.tags,
  #   {
  #     Project = each.key
  #   }
  # )
}

data "aws_caller_identity" "current" {}

resource "aws_iam_openid_connect_provider" "this" {
  for_each        = var.identity_providers
  url             = each.value["identity_provider_url"]
  client_id_list  = [each.value["audience"]]
  thumbprint_list = each.value["thumbprints"]

  # tags = local.common.tags
}

module "iam_iam-policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.9.0"

  create_policy = true
  name          = "BitbucketOIDCPolicy"
  description   = "Allows to assume a role by BitbucketOIDC roles."
  path          = "/"
  policy        = local.bitbucket_oidc_policy
  # tags          = local.common.tags
}