module "aws_account_alias" {
  source = "./modules/aws_account_alias"

  alias_prefix  = var.alias_prefix
  account_alias = var.account_alias
}

module "aws_account_alternate_contacts" {
  source = "./modules/aws_account_alternate_contact"

  contacts = var.aws_account_alternate_contacts
}

module "aws_budget_current" {
  source = "./modules/aws_budgets_budget"

  providers = {
    aws = aws.regional
  }

  name                                    = "Current Budget (${var.alias_prefix}-${var.account_alias})"
  limit_amount                            = var.budget_current_limit_amount
  notification_treshold                   = var.budget_current_notification_treshold
  threshold_type                          = "ABSOLUTE_VALUE"
  notification_type                       = "ACTUAL"
  notification_subscriber_email_addresses = var.budget_notifications_emails
}

module "aws_budget_forecasted" {
  source = "./modules/aws_budgets_budget"

  providers = {
    aws = aws.regional
  }

  name                                    = "Forecasted Budget (${var.alias_prefix}-${var.account_alias})"
  limit_amount                            = var.budget_forecasted_limit_amount
  notification_treshold                   = var.budget_forecasted_notification_treshold
  threshold_type                          = "PERCENTAGE"
  notification_type                       = "FORECASTED"
  notification_subscriber_email_addresses = var.budget_notifications_emails
}

module "aws_cost_anomaly_detection" {
  source = "./modules/aws_cloudformation_stack"

  providers = {
    aws = aws.regional
  }

  name = "anomaly-detection-${var.alias_prefix}-${var.account_alias}"
  template_body = templatefile("./templates/cost_anomaly_detection.json", {
    monitor_name       = "Cost Anomaly Detection Monitor (${var.alias_prefix}-${var.account_alias})"
    cost_threshold     = var.cost_anomaly_cost_treshold
    frequency          = var.cost_anomaly_report_frequency
    subscription_email = var.budget_notifications_emails[0]
  })
}

resource "aws_iam_account_password_policy" "this" {
  minimum_password_length        = 35
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = true
  allow_users_to_change_password = true
  password_reuse_prevention      = 24
  max_password_age               = 7
}

resource "aws_s3_account_public_access_block" "this" {
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_ebs_encryption_by_default" "this" {
  provider = aws.regional

  enabled = true
}

resource "aws_ecs_account_setting_default" "this" {
  provider = aws.regional

  name  = "containerInsights"
  value = "enabled"
}

resource "aws_inspector2_enabler" "this" {
  account_ids    = [data.aws_caller_identity.current.account_id]
  resource_types = ["EC2", "ECR", "LAMBDA"]
}
