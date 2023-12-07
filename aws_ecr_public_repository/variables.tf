variable "repository_name" {
  type = string
}

variable "about_text" {
  type    = string
  default = "Generic Image"
}

variable "description" {
  type    = string
  default = "Generic Image"
}

variable "architectures" {
  type    = list(string)
  default = ["x86-64"]
}

variable "operating_systems" {
  type    = list(string)
  default = ["Linux"]
}

variable "usage_text" {
  type    = string
  default = "Generic Image"
}
