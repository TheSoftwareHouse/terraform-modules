variable "name" {
  type = string
}

variable "image_tag_mutability" {
  type    = string
  default = "MUTABLE"
}

variable "scan_on_push" {
  type = bool
}

variable "tags" {
  type = map(string)
}

variable "ecr_max_image_count" {
  type = number
}

variable "ecr_lifecyle_policy_tag" {
  type = string
}
