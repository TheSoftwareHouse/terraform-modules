resource "aws_organizations_organization" "this" {
  aws_service_access_principals = local.aws_service_access_principals
  enabled_policy_types          = local.enabled_policy_types

  feature_set = "ALL"
}

module "aws_organizational_units" {
  source               = "./modules/aws_organizational_units"
  organizational_units = var.organizational_units
  organization_root_id = aws_organizations_organization.this.roots[0].id
}

module "aws_accounts" {
  source   = "./modules/aws_accounts"
  accounts = var.accounts
  ou_ids   = module.aws_organizational_units.ou_ids
}