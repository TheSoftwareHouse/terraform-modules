# aws_organizational_units
variable "organizational_units" {
  type        = list(any)
  description = "A nested list of Organizational Units to create in the organization."
}

# aws_accounts
variable "accounts" {
  type = map(object(
    {
      email             = string
      ou                = string
      close_on_deletion = optional(bool)
      tags              = optional(map(string))
    }
  ))
  
  description = ""
}