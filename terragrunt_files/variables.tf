variable "accounts" {
  type = map(object(
    {
      modules = optional(list(object(
        {
          name = string
          path = optional(string, "")
        }
      )))
    }
  ))
  description = ""

  validation {
    condition     = alltrue(flatten([for account in var.accounts : [for tf_module in account.modules : can(regex("^([^\\/]{1}.*[^\\/]{1})?$", tf_module.path)) if try(tf_module.path, null) != null] if try(account.modules, null) != null]))
    error_message = "A module path cannot start and end with '/' character and must be at least 2 characters long."
  }

  validation {
    condition     = alltrue(flatten([for account in var.accounts : [for tf_module in account.modules : length(tf_module.name) >= 2] if try(account.modules, null) != null]))
    error_message = "A module name must be at least 2 characters long."
  }

  validation {
    condition     = alltrue(flatten([for account in var.accounts : length([for tf_module in account.modules : tf_module.name]) == length(distinct([for tf_module in account.modules : tf_module.name])) if try(account.modules, null) != null]))
    error_message = "Each module name must be unique."
  }
}

variable "account_ids" {
  type        = map(string)
  description = ""
}

variable "default_modules" {
  type = list(object(
    {
      name = string
      path = optional(string, "")
    }
  ))
  default     = []
  description = ""

  validation {
    condition     = alltrue([for tf_module in var.default_modules : can(regex("^([^\\/]{1}.*[^\\/]{1})?$", tf_module.path)) if try(tf_module.path, null) != null])
    error_message = "A module path cannot start and end with '/' character and must be at least 2 characters long."
  }

  validation {
    condition     = alltrue([for tf_module in var.default_modules : length(tf_module.name) >= 2])
    error_message = "A module name must be at least 2 characters long."
  }

  validation {
    condition     = length([for tf_module in var.default_modules : tf_module.name]) == length(distinct([for tf_module in var.default_modules : tf_module.name]))
    error_message = "Each module name must be unique."
  }
}

variable "accounts_path" {
  type        = string
  description = ""

  validation {
    condition     = can(regex("^([^\\/]{1}.+)?$", var.accounts_path))
    error_message = "An accounts path cannot start with '/' character and must be at least 2 characters long."
  }
}

variable "templates_path" {
  type        = string
  description = ""

  validation {
    condition     = can(regex("^([^\\/]{1}.+)?$", var.templates_path))
    error_message = "A templates path cannot start with '/' character and must be at least 2 characters long."
  }
}

variable "management_account" {
  type = object(
    {
      modules = optional(list(object(
        {
          name = string
          path = optional(string, "")
        }
      )))
    }
  )
  description = ""
}

variable "management_account_name" {
  type        = string
  description = ""
}

variable "management_account_id" {
  type        = string
  description = ""
}