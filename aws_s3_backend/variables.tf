# variable "backends" {
#   type = list(object(
#     {
#       name        = string
#       account_ids = list(string)
#       tags        = map(string)
#     }
#   ))
#   description = "A map of S3 terraform backends."
# }

variable "backends" {
  type = map(any)
}