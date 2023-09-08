variable "identity_provider_url" {
  type        = string
  description = ""

  validation {
    condition     = startswith(var.identity_provider_url, "https://")
    error_message = "The identity_provider_url must begin with 'https://'."
  }
}

variable "audience" {
  type        = string
  description = ""
}

variable "thumbprints" {
  type        = list(string)
  default     = []
  description = ""
}

variable "repositories" {
  type = list(object(
    {
      name                            = string
      uuid                            = string
      environment_names               = optional(list(string), [])
      environment_uuids               = optional(list(string), [])
      iam_role_additional_policy_arns = optional(list(string), [])
    }
  ))
  default     = []
  description = ""
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = ""
}