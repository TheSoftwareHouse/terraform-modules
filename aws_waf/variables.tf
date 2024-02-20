variable "name" {
  type = string
}

variable "aws_scope" {
  type        = string
  description = "Valid Values Are REGIONAL Or CLOUDFRONT"
  default     = "REGIONAL"
}

variable "ip_address_header" {
  type        = string
  description = "HTTP Header That Cotains Real Value, Depends If Behind Cloudflare Or Not (CF-Connecting-IP)"
  default     = "X-Forwarded-For"
}
