variable "contacts" {
  type = map(object(
    {
      name          = string
      title         = string
      email_address = string
      phone_number  = string
    }
  ))
  default = {
    SECURITY = {
      name          = "DevOps Team"
      title         = "DevOps Team"
      email_address = "devops+sec@tsh.io"
      phone_number  = "+48889402822"
    }
    OPERATIONS = {
      name          = "DevOps Team"
      title         = "DevOps Team"
      email_address = "devops+ops@tsh.io"
      phone_number  = "+48889402822"
    }
  }
}
