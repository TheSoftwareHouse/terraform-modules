variable "secrets" {
  type = list(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}
