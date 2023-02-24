module "s3_bucket" {
  providers = {
    aws = aws.global
  }
  source   = "terraform-aws-modules/s3-bucket/aws"
  version  = "3.6.0"

  force_destroy           = var.bucket_force_destroy
  bucket                  = var.bucket_name
  acl                     = var.bucket_acl
  restrict_public_buckets = var.bucket_restrict_public_buckets
  block_public_acls       = var.bucket_block_public_acls
  block_public_policy     = var.bucket_block_public_policy
  ignore_public_acls      = var.bucket_ignore_public_acls

  versioning = {
    enabled = var.bucket_versioning_enabled
  }
  server_side_encryption_configuration = {}
  replication_configuration            = {}

  # tags = var.backends[each.key].tags
}

resource "aws_s3_bucket_policy" "allow_access_from_ses" {
  provider = aws.global

  bucket = module.s3_bucket.s3_bucket_id
  policy = templatefile("${path.module}/templates/s3_bucket_policy.tftpl", {
    s3_bucket_arn = module.s3_bucket.s3_bucket_arn,
    aws_referer = data.aws_caller_identity.current.account_id
  })
  depends_on = [
    module.s3_bucket
  ]
}

module "ses" {
  providers = {
    aws = aws.global
  }

  source              = "clouddrove/ses/aws"
  version             = "1.0.1"
  domain              = var.ses_domain
  iam_name            = var.ses_user
  zone_id             = var.ses_zone_id
  enable_verification = true
  enable_mx           = true
  enable_spf_domain   = false
 }

resource "aws_ses_receipt_rule_set" "custom_rule_set" {
  provider = aws.global
  rule_set_name = "s3-emails-forwarding"
}

# Add a header to the email and store it in S3
resource "aws_ses_receipt_rule" "s3_email_forwarding" {
  provider = aws.global
  name          = "store"
  rule_set_name = aws_ses_receipt_rule_set.custom_rule_set.id
  recipients    = ["aws@cholewa.io"]
  enabled       = true
  scan_enabled  = true

  add_header_action {
    header_name  = "Custom-Header"
    header_value = "Added by SES"
    position     = 1
  }

  s3_action {
    bucket_name = var.bucket_name
    position    = 2
  }

  depends_on = [
    aws_ses_receipt_rule_set.custom_rule_set,
    module.s3_bucket
  ]
}

resource "aws_ses_active_receipt_rule_set" "main" {
  provider = aws.global
  rule_set_name = aws_ses_receipt_rule_set.custom_rule_set.id
}
