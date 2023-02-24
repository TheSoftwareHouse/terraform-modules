variable "alias" {
  type        = string
  description = "AWS account alias name. If the alias, prefix and suffix together exceed 31 characters, the alias will be shortened to 31 characters by truncating the excess ending."

  validation {
    condition     = can(regex("^[0-9a-z]{1}([0-9a-z-]?[0-9a-z]{1}){1,31}$", var.alias))
    error_message = "Account alias must be unique across AWS products and must be alphanumeric. An alias must be lowercase, it must not start or end with a hyphen, it cannot contain two consecutive hyphens and it cannot be a 12-digit number. The minimum number of characters is 2 and maximum is 31."
  }
}

variable "alias_prefix" {
  type        = string
  default     = ""
  description = "AWS account alias prefix. If the alias, prefix and suffix together exceed 31 characters, the alias will be shortened to 31 characters by truncating the excess ending."

  validation {
    condition     = can(regex("^[0-9a-z]{0,10}$", var.alias_prefix))
    error_message = "Account alias prefix must be alphanumeric and must be lowercase. The maximum number of characters is 10."
  }
}

variable "alias_suffix" {
  type        = string
  default     = ""
  description = "AWS account alias suffix. If the alias, prefix and suffix together exceed 31 characters, the alias will be shortened to 31 characters by truncating the excess ending."

  validation {
    condition     = can(regex("^[0-9a-z]{0,10}$", var.alias_suffix))
    error_message = "Account alias suffix must be alphanumeric and must be lowercase. The maximum number of characters is 10."
  }
}