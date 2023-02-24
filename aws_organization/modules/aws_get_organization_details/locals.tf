locals {
  # Organizational Units
  list_of_roots   = flatten([for i in data.aws_organizations_organization.this.roots : { name = i.name, id = i.id }])
  list_of_level_1 = flatten([for i in data.aws_organizations_organizational_units.root : [for j in i.children : { name = j.name, id = j.id }]])
  list_of_level_2 = flatten([for i in data.aws_organizations_organizational_units.level_1 : [for j in i.children : { name = j.name, id = j.id }]])
  list_of_level_3 = flatten([for i in data.aws_organizations_organizational_units.level_2 : [for j in i.children : { name = j.name, id = j.id }]])
  list_of_level_4 = flatten([for i in data.aws_organizations_organizational_units.level_3 : [for j in i.children : { name = j.name, id = j.id }]])
  list_of_level_5 = flatten([for i in data.aws_organizations_organizational_units.level_4 : [for j in i.children : { name = j.name, id = j.id }]])

  root    = { for root in local.list_of_roots : root.name => root.id }
  level_1 = { for ou in local.list_of_level_1 : ou.name => ou.id }
  level_2 = { for ou in local.list_of_level_2 : ou.name => ou.id }
  level_3 = { for ou in local.list_of_level_3 : ou.name => ou.id }
  level_4 = { for ou in local.list_of_level_4 : ou.name => ou.id }
  level_5 = { for ou in local.list_of_level_5 : ou.name => ou.id }

  ou_ids = merge(
    local.root,
    local.level_1,
    local.level_2,
    local.level_3,
    local.level_4,
    local.level_5
  )

  # Accounts
  account_ids = { for account in data.aws_organizations_organization.this.accounts : account.name => account.id }
}