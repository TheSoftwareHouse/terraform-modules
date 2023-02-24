# S3 Bucket
variable bucket_name {
  type = string
}

variable bucket_force_destroy {
  type = bool
  default = true
}

variable bucket_acl {
  type = string
  default = "private"
}

variable bucket_restrict_public_buckets {
  type = bool
  default = true
}

variable bucket_block_public_acls {
  type = bool
  default = true
}

variable bucket_block_public_policy {
  type = bool
  default = true
}

variable bucket_ignore_public_acls {
  type = bool
  default = true
}

variable bucket_versioning_enabled {
  type = bool
  default = true
}

# SES
variable ses_domain {
  type = string
}

variable ses_user {
  type = string
  default = "ses_user"
}

variable ses_zone_id {
  type = string
}
