resource "azurerm_management_group" "level_1" {
  for_each                   = local.level_1
  display_name               = each.key
  parent_management_group_id = null
  subscription_ids           = []

  lifecycle {
    ignore_changes = [subscription_ids]
  }
}

resource "azurerm_management_group" "level_2" {
  for_each                   = local.level_2
  display_name               = each.key
  parent_management_group_id = each.value["parent_id"]
  subscription_ids           = []

  lifecycle {
    ignore_changes = [subscription_ids]
  }

  depends_on = [azurerm_management_group.level_1]
}

resource "azurerm_management_group" "level_3" {
  for_each                   = local.level_3
  display_name               = each.key
  parent_management_group_id = each.value["parent_id"]
  subscription_ids           = []

  lifecycle {
    ignore_changes = [subscription_ids]
  }

  depends_on = [azurerm_management_group.level_2]
}

resource "azurerm_management_group" "level_4" {
  for_each                   = local.level_4
  display_name               = each.key
  parent_management_group_id = each.value["parent_id"]
  subscription_ids           = []

  lifecycle {
    ignore_changes = [subscription_ids]
  }

  depends_on = [azurerm_management_group.level_3]
}

resource "azurerm_management_group" "level_5" {
  for_each                   = local.level_5
  display_name               = each.key
  parent_management_group_id = each.value["parent_id"]
  subscription_ids           = []

  lifecycle {
    ignore_changes = [subscription_ids]
  }

  depends_on = [azurerm_management_group.level_4]
}

resource "azurerm_management_group" "level_6" {
  for_each                   = local.level_6
  display_name               = each.key
  parent_management_group_id = each.value["parent_id"]
  subscription_ids           = []

  lifecycle {
    ignore_changes = [subscription_ids]
  }

  depends_on = [azurerm_management_group.level_5]
}