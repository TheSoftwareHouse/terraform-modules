variable "organization_units" {
  type = map(object(
    {
      parent_id = string
    }
  ))
}

variable "tags" {
  type = map(string)
}
