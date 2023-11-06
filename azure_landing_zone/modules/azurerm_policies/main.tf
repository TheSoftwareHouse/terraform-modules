data "azurerm_management_group" "root_group" {
  for_each     = var.policies
  display_name = "Tenant Root Group"
}

resource "azurerm_policy_definition" "this" {
  for_each            = var.policies
  name                = each.key
  display_name        = each.value.policy_display_name
  description         = each.value.policy_description
  policy_type         = each.value.policy_type
  mode                = each.value.policy_mode
  management_group_id = data.azurerm_management_group.root_group[each.key].id

  policy_rule = each.value.policy_rule
}

data "azurerm_management_group" "assignment_group" {
  for_each     = { for assignment in local.policy_assignments : "${assignment.assignment_key}" => assignment }
  display_name = each.value.assignment_group
}

resource "azurerm_management_group_policy_assignment" "this" {
  for_each             = { for assignment in local.policy_assignments : "${assignment.assignment_key}" => assignment }
  name                 = each.value.assignment_name
  policy_definition_id = azurerm_policy_definition.this[each.value.policy_key].id
  management_group_id  = data.azurerm_management_group.assignment_group[each.key].id

  non_compliance_message {
    content = each.value.assignment_non_compliance_message
  }

  not_scopes = each.value.assignment_non_scopes
}