variable "accounts" {
  type = map(object(
    {
      email             = string
      organization_unit = string
    }
  ))
}

variable "tags" {
  type = map(string)
}
