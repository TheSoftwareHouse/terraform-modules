variable "filename" {
  type = string
}

variable "function_name" {
  type = string
}

variable "description" {
  type = string
}

variable "role" {
  type = string
}

variable "handler" {
  type = string
}

variable "runtime" {
  type = string
}

variable "architectures" {
  type    = list(any)
  default = ["x86_64"]
}

variable "package_type" {
  type    = string
  default = "Zip"
}

variable "reserved_concurrent_executions" {
  type    = number
  default = -1
}

variable "timeout" {
  type    = number
  default = 5
}

variable "memory_size" {
  type    = number
  default = 128
}

variable "tags" {
  type = map(string)
}

variable "environment_variables" {
  type      = map(string)
  default   = {}
  sensitive = true
}
