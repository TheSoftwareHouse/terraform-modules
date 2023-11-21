variable "name" {
  type = string
}

variable "description" {
  type    = string
  default = "IAM Role"
}

variable "assume_role_policy" {
  type = string
}

variable "managed_policy_arns" {
  type = list(any)
}

variable "tags" {
  type = map(string)
}

variable "inline_policies" {
  type    = list(any)
  default = []
}

variable "max_session_duration" {
  type    = string
  default = 3600
}
