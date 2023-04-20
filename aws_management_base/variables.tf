variable "name" {
  type    = string
  default = "DeploymentsRole"
}

variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "aws_organization_root_id" {
  type = string
}

variable "aws_trusted_entity" {
  type = list(string)
}
