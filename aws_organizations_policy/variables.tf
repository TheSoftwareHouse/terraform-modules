variable "policies" {
  type = map(object(
    {
      name              = string
      content           = string
      description       = string
      type              = string
      tags              = map(string)
      policy_target_id  = string
    }
  ))
  default = {
    name             = ""
    content          = ""
    description      = "Service Control Policy attached to organization."
    type             = "SERVICE_CONTROL_POLICY"
    tags             = []
    policy_target_id = ""
  }
}
