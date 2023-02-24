variable "accounts" {
  type = map(object(
    {
      email = string
      ou    = string

      modules = optional(list(object(
        {
          name = optional(string)
          path = optional(string)
        }
      )))

      shared_settings = optional(object(
        {
          id = optional(string)
          providers = optional(map(object(
            {
              enabled = optional(bool)
              # bitbucket_oidc
              repository_uuids = optional(list(string))
            }
          )))
          backend = optional(object(
            {
              enabled = optional(bool)
            }
          ))
        }
      ))
    }
  ))
}

variable "management_account" {
  type = object(
    {
      modules = optional(list(object(
        {
          name = optional(string)
          path = optional(string)
        }
      )))

      shared_settings = optional(object(
        {
          id = optional(string)
          providers = optional(map(object(
            {
              enabled = optional(bool)
              # bitbucket_oidc
              repository_uuids = optional(list(string))
            }
          )))
        }
      ))
    }
  )
}

variable "management_account_name" {
  type        = string
  description = "A name of the management account."

  validation {
    condition     = can(regex("^[\\w]{1}([\\w\\s/_-]{0,1}[\\w]{1}){1,31}$", var.management_account_name))
    error_message = "An account name must consist of characters in the ranges [0-9a-zA-Z/_-] and whitespaces. It must start and end with an alphanumeric characters. It cannot contain two consecutive characters in the range [/_-] and whitespaces."
  }
}

variable "identity_providers" {
  type = map(object(
    {
      type = string
      # bitbucket_oidc
      identity_provider_url = optional(string)
      audience              = optional(string)
      thumbprints           = optional(list(string))
    }
  ))
  description = ""
  default     = {}
}