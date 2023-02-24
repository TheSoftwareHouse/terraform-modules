variable "organizational_units" {
  type        = list(any)
  description = "A list of Organizational Units with their children. Maximum nesting is limited to 5 levels."
}

variable "organization_root_id" {
  type    = string
  default = ""
}