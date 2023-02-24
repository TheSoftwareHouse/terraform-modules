# Organizational Units
data "aws_organizations_organization" "this" {}

data "aws_organizations_organizational_units" "root" {
  for_each  = local.root
  parent_id = each.value
}

data "aws_organizations_organizational_units" "level_1" {
  for_each  = local.level_1
  parent_id = each.value
}

data "aws_organizations_organizational_units" "level_2" {
  for_each  = local.level_2
  parent_id = each.value
}

data "aws_organizations_organizational_units" "level_3" {
  for_each  = local.level_3
  parent_id = each.value
}

data "aws_organizations_organizational_units" "level_4" {
  for_each  = local.level_4
  parent_id = each.value
}

data "aws_organizations_organizational_units" "level_5" {
  for_each  = local.level_5
  parent_id = each.value
}