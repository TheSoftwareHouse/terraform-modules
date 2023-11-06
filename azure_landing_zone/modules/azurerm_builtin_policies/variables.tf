variable "builtin_policies" {
  type = map(object({
    management_group_display_name     = string
    policy_definition_display_name    = string
    assignment_name                   = string
    assignment_display_name           = string
    assignment_description            = string
    assignment_parameters             = any
    assignment_non_compliance_message = string
    assignment_non_scopes             = list(string)
  }))

  description = "Configuration of the builtin policies."

  validation {
    condition = !contains([
    for i in var.builtin_policies : can(regex("^[0-9A-Za-z\\s]{3,24}$", i.assignment_name))], false)
    error_message = "Assignment name has to be between 3 - 24 characters"
  }

  validation {
    condition = !contains(flatten([for i in var.builtin_policies :
    [for j in i.assignment_non_scopes : can(regex("^providers/Microsoft.Management/managementGroups/", j))]]), false)
    error_message = "Non scopes must start with 'providers/Microsoft.Management/managementGroups/'"
  }
}