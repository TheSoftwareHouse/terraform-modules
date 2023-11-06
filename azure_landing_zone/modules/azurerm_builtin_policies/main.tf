data "azurerm_management_group" "this" {
  for_each     = var.builtin_policies
  display_name = each.value.management_group_display_name
}

data "azurerm_policy_definition" "this" {
  for_each     = var.builtin_policies
  display_name = each.value.policy_definition_display_name
}

resource "azurerm_management_group_policy_assignment" "this" {
  for_each             = var.builtin_policies
  name                 = each.value.assignment_name
  display_name         = each.value.assignment_display_name
  management_group_id  = data.azurerm_management_group.this[each.key].id
  policy_definition_id = data.azurerm_policy_definition.this[each.key].id
  parameters           = jsonencode(each.value.assignment_parameters)

  non_compliance_message {
    content = each.value.assignment_non_compliance_message
  }

  not_scopes = each.value.assignment_non_scopes
}