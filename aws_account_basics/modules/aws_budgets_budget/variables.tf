variable "name" {
  type = string
}

variable "budget_type" {
  type    = string
  default = "COST"
}

variable "limit_amount" {
  type = string
}

variable "limit_unit" {
  type    = string
  default = "USD"
}

variable "time_unit" {
  type    = string
  default = "MONTHLY"
}

variable "comparison_operator" {
  type    = string
  default = "GREATER_THAN"
}

variable "notification_treshold" {
  type    = number
  default = 80
}

variable "threshold_type" {
  type    = string
  default = "PERCENTAGE"
}

variable "notification_type" {
  type    = string
  default = "FORECASTED"
}

variable "notification_subscriber_email_addresses" {
  type = list(string)
}
