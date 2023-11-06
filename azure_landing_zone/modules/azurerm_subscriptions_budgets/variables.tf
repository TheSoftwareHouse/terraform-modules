variable "subscriptions" {
  type = map(object({
    subscription_name            = string
    subscription_tags            = optional(map(string))
    billing_account_name         = string
    billing_profile_name         = string
    invoice_section_name         = string
    parent_management_group_name = string
    budget_name                  = string
    budget_amount                = number
    budget_time_grain            = string
    budget_start_date            = string
    budget_end_date              = string
    budget_notifications = list(object({
      enabled        = bool
      threshold      = number
      operator       = string
      threshold_type = string
      contact_emails = list(string)
    }))
  }))
  description = "Configuration of subscriptions."

  validation {
    condition = !contains([
    for i in var.subscriptions : can(regex("^[0-9A-Z]{4}-[0-9A-Z]{4}-[0-9A-Z]{3}-[0-9A-Z]{3}$", i.invoice_section_name))], false)
    error_message = "Invoice section name must be in XXXX-XXXX-XXX-XXX form."
  }

  validation {
    condition = !contains([
    for i in var.subscriptions : can(regex("^[0-9]{4}-[0-9]{2}-[01]{2}$", i.budget_start_date))], false)
    error_message = "Budget start date must be in XXXX-XX-XX format and be first day of the month."
  }

  validation {
    condition = !contains([
    for i in var.subscriptions : can(regex("^[0-9]{4}-[0-9]{2}-[0-9]{2}$", i.budget_end_date))], false)
    error_message = "Budget end date must be in XXXX-XX-XX format."
  }

  validation {
    condition = alltrue(flatten([
      for i in var.subscriptions : [
        for j in i.budget_notifications : contains(["EqualTo", "GreaterThan", "GreaterThanOrEqualTo"], j.operator)
    ]]))
    error_message = "Operator must be one of EqualTo, GreaterThan or GreaterThanOrEqualTo"
  }

  validation {
    condition = alltrue(flatten([
      for i in var.subscriptions : [
        for j in i.budget_notifications : contains(["Actual", "Forecasted"], j.threshold_type)
    ]]))
    error_message = "Threshold type must be either Actual or Forecasted"
  }
}