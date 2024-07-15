variable "enabled" {
  description = "Whether the config recorder is enabled"
  type        = bool
  default     = true
}

variable "recorder_name" {
  description = "The name of the AWS Config recorder"
  type        = string
}

variable "role_arn" {
  description = "The ARN of the IAM role that AWS Config uses to record configurations on your behalf"
  type        = string
}

variable "config_rules" {
  description = "List of configuration rules"
  type = list(object({
    name       = string
    source     = object({
      owner              = string
      identifier         = string
      detail             = object({
        event_source               = string
        message_type               = string
        maximum_execution_frequency = string
      })
    })
    input_parameters               = optional(string, "{}")
    maximum_execution_frequency     = optional(string, "TwentyFour_Hours")
    scope                           = object({
      compliance_resource_id       = optional(string, null)
      compliance_resource_types    = optional(list(string), [])
      tag_key                      = optional(string, null)
      tag_value                    = optional(string, null)
    })
  }))
}

variable "enable_alerting" {
  description = "Whether to enable alerting"
  type        = bool
  default     = false
}

variable "sns_topic_name" {
  description = "The name of the SNS topic for alerts"
  type        = string
  default     = "config-alerts"
}
