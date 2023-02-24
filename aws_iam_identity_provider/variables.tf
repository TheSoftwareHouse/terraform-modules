variable "permission_sets" {
  type = map(object(
    {
      description               = optional(string)
      relay_state               = optional(string)
      session_duration          = optional(string)
      predefined_permission_set = optional(string)
      custom_permission_set     = optional(string)
    }
  ))
  description = "A map of permission sets to be created in the organization."

  validation {
    condition     = alltrue([for i in var.permission_sets : i.custom_permission_set == null if try(i.predefined_permission_set, null) != null])
    error_message = "A predefined_permission_set cannot be set together with a custom_permission_set in the same object."
  }

  # Predefined permision set
  validation { # Predefined permission set must be one of the AWS managed policy (predefined permission set list)
    condition     = alltrue([for i in var.permission_sets : contains(["AdministratorAccess", "Billing", "DatabaseAdministrator", "DataScientist", "NetworkAdministrator", "PowerUserAccess", "SecurityAudit", "SupportUser", "SystemAdministrator", "ViewOnlyAccess"], i.predefined_permission_set) if try(i.predefined_permission_set, null) != null])
    error_message = "A predefined_permission_set value must be one of the following: 'AdministratorAccess', 'Billing', 'DatabaseAdministrator', 'DataScientist', 'NetworkAdministrator', 'PowerUserAccess', 'SecurityAudit', 'SupportUser', 'SystemAdministrator', 'ViewOnlyAccess'."
  }

  validation {
    condition     = length([for i in var.permission_sets : i.predefined_permission_set if try(i.predefined_permission_set, null) != null]) == length(distinct([for i in var.permission_sets : i.predefined_permission_set if try(i.predefined_permission_set, null) != null]))
    error_message = "All predefined_permission_set values must be unique."
  }

  # Custom permision set
  validation { # Policy must be JSON code
    condition     = alltrue([for i in var.permission_sets : can(jsondecode(i.custom_permission_set)) if try(i.custom_permission_set, null) != null])
    error_message = "A custom_permission_set value must be valid JSON code."
  }
}