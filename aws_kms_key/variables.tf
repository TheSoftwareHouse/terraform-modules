variable "description" {
  type = string
}

variable "enable_key_rotation" {
  type = bool
}

variable "deletion_window_in_days" {
  type = number
}

variable "key_usage" {
  type    = string
  default = "ENCRYPT_DECRYPT"
}

variable "customer_master_key_spec" {
  type    = string
  default = "SYMMETRIC_DEFAULT"
}

variable "is_enabled" {
  type    = bool
  default = true
}

variable "multi_region" {
  type    = bool
  default = false
}

variable "policy" {
  type = string
}

variable "tags" {
  type = map(string)
}
