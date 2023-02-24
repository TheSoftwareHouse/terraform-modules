variable "identity_providers" {
  type = map(object(
    {
      identity_provider_url = string
      audience              = string
      thumbprints           = list(string)
    }
  ))
  description = ""

  validation {
    condition     = alltrue([for provider in var.identity_providers : startswith(provider.identity_provider_url, "https://")])
    error_message = "The identity_provider_url must begin with 'https://'."
  }

  validation {
    condition     = alltrue([for provider in var.identity_providers : length(provider.thumbprints) <= 5 && length(provider.thumbprints) == length(distinct(provider.thumbprints))])
    error_message = "All thumbprints must be unique. The maximum number is 5."
  }
}

variable "roles" {
  type = map(object(
    {
      provider         = string
      repository_uuids = list(string)
    }
  ))
  description = ""

  validation {
    condition     = alltrue([for role in var.roles : can([for repo in role.repository_uuids : regex("^{([0-9a-z]+[-])+([0-9a-z]+)}$", repo)])])
    error_message = "The repository_uuid must consist of characters in the ranges [a-z], [0-9] and '-'. The repository_uuid must start with '{' and end with '}' characters."
  }
}