variable "contacts" {
  type = map(object(
    {
      name          = string
      title         = string
      email_address = string
      phone_number  = string
    }
  ))
}
