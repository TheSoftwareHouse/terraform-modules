locals {
  list_of_level_1 = flatten([for i in var.organizational_units : { name = i.name, parent_ou = "root" }])
  list_of_level_2 = flatten([for i in var.organizational_units : [for j in lookup(i, "children", []) : { name = j.name, parent_ou = i.name }]])
  list_of_level_3 = flatten([for i in var.organizational_units : [for j in lookup(i, "children", []) : [for k in lookup(j, "children", []) : { name = k.name, parent_ou = j.name }]]])
  list_of_level_4 = flatten([for i in var.organizational_units : [for j in lookup(i, "children", []) : [for k in lookup(j, "children", []) : [for l in lookup(k, "children", []) : { name = l.name, parent_ou = k.name }]]]])
  list_of_level_5 = flatten([for i in var.organizational_units : [for j in lookup(i, "children", []) : [for k in lookup(j, "children", []) : [for l in lookup(k, "children", []) : [for m in lookup(l, "children", []) : { name = m.name, parent_ou = l.name }]]]]])

  level_1 = { for ou in local.list_of_level_1 : ou.name => { parent_id = ou.parent_ou, tags = lookup(ou, "tags", {}) } }
  level_2 = { for ou in local.list_of_level_2 : ou.name => { parent_id = "${aws_organizations_organizational_unit.level_1[ou.parent_ou].id}", tags = lookup(ou, "tags", {}) } }
  level_3 = { for ou in local.list_of_level_3 : ou.name => { parent_id = "${aws_organizations_organizational_unit.level_2[ou.parent_ou].id}", tags = lookup(ou, "tags", {}) } }
  level_4 = { for ou in local.list_of_level_4 : ou.name => { parent_id = "${aws_organizations_organizational_unit.level_3[ou.parent_ou].id}", tags = lookup(ou, "tags", {}) } }
  level_5 = { for ou in local.list_of_level_5 : ou.name => { parent_id = "${aws_organizations_organizational_unit.level_4[ou.parent_ou].id}", tags = lookup(ou, "tags", {}) } }
}