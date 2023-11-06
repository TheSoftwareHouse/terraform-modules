locals {
  list_of_level_1 = flatten([for i in var.management_groups : { display_name = i.display_name, parent_group_id = null }])
  list_of_level_2 = flatten([for i in var.management_groups : [for j in lookup(i, "children", []) : { display_name = j.display_name, parent_group_id = i.display_name }]])
  list_of_level_3 = flatten([for i in var.management_groups : [for j in lookup(i, "children", []) : [for k in lookup(j, "children", []) : { display_name = k.display_name, parent_group_id = j.display_name }]]])
  list_of_level_4 = flatten([for i in var.management_groups : [for j in lookup(i, "children", []) : [for k in lookup(j, "children", []) : [for l in lookup(k, "children", []) : { display_name = l.display_name, parent_group_id = k.display_name }]]]])
  list_of_level_5 = flatten([for i in var.management_groups : [for j in lookup(i, "children", []) : [for k in lookup(j, "children", []) : [for l in lookup(k, "children", []) : [for m in lookup(l, "children", []) : { display_name = m.display_name, parent_group_id = l.display_name }]]]]])
  list_of_level_6 = flatten([for i in var.management_groups : [for j in lookup(i, "children", []) : [for k in lookup(j, "children", []) : [for l in lookup(k, "children", []) : [for m in lookup(l, "children", []) : [for n in lookup(m, "children", []) : { display_name = n.display_name, parent_group_id = m.display_name }]]]]]])
  level_1         = { for grp in local.list_of_level_1 : grp.display_name => { parent_id = grp.parent_group_id, tags = lookup(grp, "tags", {}) } }
  level_2         = { for grp in local.list_of_level_2 : grp.display_name => { parent_id = "${azurerm_management_group.level_1[grp.parent_group_id].id}", tags = lookup(grp, "tags", {}) } }
  level_3         = { for grp in local.list_of_level_3 : grp.display_name => { parent_id = "${azurerm_management_group.level_2[grp.parent_group_id].id}", tags = lookup(grp, "tags", {}) } }
  level_4         = { for grp in local.list_of_level_4 : grp.display_name => { parent_id = "${azurerm_management_group.level_3[grp.parent_group_id].id}", tags = lookup(grp, "tags", {}) } }
  level_5         = { for grp in local.list_of_level_5 : grp.display_name => { parent_id = "${azurerm_management_group.level_4[grp.parent_group_id].id}", tags = lookup(grp, "tags", {}) } }
  level_6         = { for grp in local.list_of_level_6 : grp.display_name => { parent_id = "${azurerm_management_group.level_5[grp.parent_group_id].id}", tags = lookup(grp, "tags", {}) } }
}