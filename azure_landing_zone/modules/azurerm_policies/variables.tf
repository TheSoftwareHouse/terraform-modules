variable "policies" {
  type = map(object({
    policy_display_name = string
    policy_description  = string
    policy_type         = string
    policy_mode         = string
    policy_rule         = any
    assignments = map(object({
      assignment_name                   = string
      assignment_group                  = string
      assignment_non_compliance_message = string
      assignment_non_scopes             = list(string)
    }))
  }))
  description = "Configuration of the policies."

  validation {
    condition = alltrue([
      for i in var.policies : contains(["BuiltIn", "Custom", "NotSpecified", "Static"], i.policy_type)
    ])
    error_message = "Policy has to be a type of BuiltIn, Custom, NotSpecified, or Static"
  }

  validation {
    condition = alltrue([
      for i in var.policies : contains(["All", "Indexed", "Microsoft.ContainerService.Data", "Microsoft.CustomerLockbox.Data",
        "Microsoft.DataCatalog.Data", "Microsoft.KeyVault.Data", "Microsoft.Kubernetes.Data", "Microsoft.MachineLearningServices.Data",
      "Microsoft.Network.Data", "Microsoft.Synapse.Data"], i.policy_mode)
    ])
    error_message = "Policy mode must be one of All, Indexed, Microsoft.ContainerService.Data, Microsoft.CustomerLockbox.Data, Microsoft.DataCatalog.Data, Microsoft.KeyVault.Data, Microsoft.Kubernetes.Data, Microsoft.MachineLearningServices.Data, Microsoft.Network.Data, Microsoft.Synapse.Data"
  }

  validation {
    condition = !contains(flatten([for i in var.policies : [for assignment in i.assignments :
    [for j in assignment.assignment_non_scopes : can(regex("^providers/Microsoft.Management/managementGroups/", j))]]]), false)
    error_message = "Non scopes must start with 'providers/Microsoft.Management/managementGroups/'"
  }
}