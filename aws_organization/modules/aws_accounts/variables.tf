variable "accounts" {
  type = map(object(
    {
      email             = string
      ou                = string
      close_on_deletion = optional(bool)
      tags              = optional(map(string))
    }
  ))

  description = "A map of accounts ..."

  validation {
    condition     = alltrue([for account_name, account in var.accounts : can(regex("^[\\w]{1}([\\w\\s/_-]{0,1}[\\w]{1}){1,31}$", account_name))])
    error_message = "The account name must consist of characters in the ranges [0-9a-zA-Z/_-] and whitespaces. It must start and end with an alphanumeric characters. It cannot contain two consecutive characters in the range [/_-] and whitespaces."
  }
}

variable "ou_ids" {
  type        = map(string)
  description = "description"
}

variable "organization_account_access_role_name" {
  type        = string
  default     = "OrganizationAccountAccessRole"
  description = "description"
}