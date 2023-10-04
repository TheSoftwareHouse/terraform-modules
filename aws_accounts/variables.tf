variable "accounts" {
  type = map(object(
    {
      email             = string
      organization_unit = string
      tags              = map(string)
    }
  ))
}
