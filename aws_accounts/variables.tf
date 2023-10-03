variable "accounts" {
  type = map(object(
    {
      email             = string
      organization_unit = string
      sechub_jira_integration_config = optional(object(
        {
          security_contact_LZ  = string # Osoba (imię nazwisko), do której przypisany będzie ticket dot. Landing Zone, ew. "Unassigned"
          security_contact_app = string # Osoba (imię nazwisko), do której przypisany będzie ticket dot. infrastruktury aplikacji, ew. "Unassigned"
          security_level       = string # Poziom zabezpieczeń konta ["Production"|"Non-production"|"Sandbox"]
          project_key_LZ       = string # Project Key w Jira, gdzie utworzony będzie ticket dot. Landing Zone
          project_key_app      = string # Project Key w Jira, gdzie utworzony będzie ticket dot. aplikacji
        }
      ))
    }
  ))
  validation {
    condition = alltrue([
      for account in var.accounts :
      try(contains(["Production", "Non-production", "Sandbox"], account.sechub_jira_integration_config.security_level), true)
    ])
    error_message = "If set, security_level must be either Production, Non-production or Sandbox"
  }
}

variable "tags" {
  type = map(string)
}
