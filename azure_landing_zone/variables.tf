variable "management_groups" {
  type        = list(any)
  description = "A list of Management Groups with their children. Maximum nesting is limited to 6 levels."
}

variable "subscriptions" {
  type        = map(any)
  description = "Configuration of subscriptions."
}

variable "builtin_policies" {
  type        = map(any)
  description = "Configuration of the builtin policies."
}

variable "policies" {
  type        = map(any)
  description = "Configuration of the policies."
}