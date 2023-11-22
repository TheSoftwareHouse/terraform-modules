variable "name" {
  type    = string
  default = "DeploymentsRole"
}

variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "aws_organization_root_id" {
  type = string
}

variable "aws_trusted_entity" {
  type = list(string)
}

variable "alias_prefix" {
  type        = string
  description = "Prefix For Account Aliases"
}

variable "account_alias" {
  type        = string
  description = "Alias For Account"
}

variable "aws_account_alternate_contacts" {
  type = map(object(
    {
      name          = string
      title         = string
      email_address = string
      phone_number  = string
    }
  ))
}

variable "budget_current_limit_amount" {
  type    = string
  default = "50"
}

variable "budget_forecasted_limit_amount" {
  type    = string
  default = "50"
}

variable "budget_current_notification_treshold" {
  type    = number
  default = 40
}

variable "budget_forecasted_notification_treshold" {
  type    = number
  default = 90
}

variable "budget_notifications_emails" {
  type    = list(string)
  default = []
}

variable "cost_anomaly_cost_treshold" {
  type    = number
  default = 20
}

variable "cost_anomaly_report_frequency" {
  type    = string
  default = "DAILY"
}

variable "s3_block_public_access" {
  type    = bool
  default = true
}
