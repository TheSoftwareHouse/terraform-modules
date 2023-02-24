resource "aws_organizations_organizational_unit" "level_1" {
  for_each  = local.level_1
  name      = each.key
  parent_id = each.value["parent_id"] != "root" ? each.value["parent_id"] : var.organization_root_id
  tags      = each.value["tags"]
}

resource "aws_organizations_organizational_unit" "level_2" {
  for_each  = local.level_2
  name      = each.key
  parent_id = each.value["parent_id"]
  tags      = each.value["tags"]

  depends_on = [aws_organizations_organizational_unit.level_1]
}

resource "aws_organizations_organizational_unit" "level_3" {
  for_each  = local.level_3
  name      = each.key
  parent_id = each.value["parent_id"]
  tags      = each.value["tags"]

  depends_on = [aws_organizations_organizational_unit.level_2]
}

resource "aws_organizations_organizational_unit" "level_4" {
  for_each  = local.level_4
  name      = each.key
  parent_id = each.value["parent_id"]
  tags      = each.value["tags"]

  depends_on = [aws_organizations_organizational_unit.level_3]
}

resource "aws_organizations_organizational_unit" "level_5" {
  for_each  = local.level_5
  name      = each.key
  parent_id = each.value["parent_id"]
  tags      = each.value["tags"]

  depends_on = [aws_organizations_organizational_unit.level_4]
}