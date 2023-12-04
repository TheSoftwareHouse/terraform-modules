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
}
