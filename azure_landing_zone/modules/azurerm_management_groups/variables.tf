variable "management_groups" {
  type        = list(any)
  description = "A list of Management Groups with their children. Maximum nesting is limited to 6 levels."
}