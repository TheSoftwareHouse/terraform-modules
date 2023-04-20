variable "name" {
  type    = string
  default = "DeploymentsRole"
}

variable "aws_trusted_entity" {
  type = list(string)
}
