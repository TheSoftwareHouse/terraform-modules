resource "aws_budgets_budget" "this" {
  name         = var.name
  budget_type  = var.budget_type
  limit_amount = var.limit_amount
  limit_unit   = var.limit_unit
  time_unit    = var.time_unit

  notification {
    comparison_operator        = var.comparison_operator
    threshold                  = var.notification_treshold
    threshold_type             = var.threshold_type
    notification_type          = var.notification_type
    subscriber_email_addresses = var.notification_subscriber_email_addresses
  }
}
