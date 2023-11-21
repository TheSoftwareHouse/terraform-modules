variable "name" {
  type = string
}

variable "description" {
  type = string
}

variable "kms_key_id" {
  type = string
}

variable "recovery_window_in_days" {
  type    = number
  default = 7
}
