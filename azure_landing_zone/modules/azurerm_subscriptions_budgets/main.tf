data "azurerm_billing_mca_account_scope" "this" {
  for_each             = var.subscriptions
  billing_account_name = each.value.billing_account_name
  billing_profile_name = each.value.billing_profile_name
  invoice_section_name = each.value.invoice_section_name
}

data "azurerm_management_group" "this" {
  for_each     = var.subscriptions
  display_name = each.value.parent_management_group_name
}

resource "azurerm_subscription" "this" {
  for_each          = var.subscriptions
  subscription_name = each.value.subscription_name
  billing_scope_id  = data.azurerm_billing_mca_account_scope.this[each.key].id
  tags              = each.value.subscription_tags
}

data "azurerm_subscription" "this" {
  for_each        = var.subscriptions
  subscription_id = azurerm_subscription.this[each.key].subscription_id
}

resource "azurerm_management_group_subscription_association" "this" {
  for_each            = var.subscriptions
  management_group_id = data.azurerm_management_group.this[each.key].id
  subscription_id     = data.azurerm_subscription.this[each.key].id
}

resource "azurerm_consumption_budget_subscription" "this" {
  for_each = var.subscriptions

  name            = each.value.budget_name
  subscription_id = data.azurerm_subscription.this[each.key].id

  amount     = each.value.budget_amount
  time_grain = each.value.budget_time_grain

  time_period {
    start_date = format("%sT00:00:00Z", each.value.budget_start_date)
    end_date   = format("%sT00:00:00Z", each.value.budget_end_date)
  }

  dynamic "notification" {
    for_each = each.value.budget_notifications
    content {
      enabled        = notification.value["enabled"]
      threshold      = notification.value["threshold"]
      operator       = notification.value["operator"]
      threshold_type = notification.value["threshold_type"]
      contact_emails = notification.value["contact_emails"]
    }
  }
}