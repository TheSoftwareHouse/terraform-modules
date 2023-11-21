data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_cloudtrail" "this" {
  name                          = "${var.name}-cloudtrail"
  enable_logging                = true
  is_multi_region_trail         = true
  is_organization_trail         = true
  enable_log_file_validation    = true
  s3_bucket_name                = aws_s3_bucket.this.id
  include_global_service_events = true
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.this.arn}:*"
  cloud_watch_logs_role_arn     = aws_iam_role.cloudtrail.arn
  kms_key_id                    = aws_kms_key.this.arn

  insight_selector {
    insight_type = "ApiCallRateInsight"
  }
}

resource "aws_kms_key" "this" {
  description              = "KMS Key for Cloudtrail"
  key_usage                = "ENCRYPT_DECRYPT"
  is_enabled               = true
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  enable_key_rotation      = true
  deletion_window_in_days  = 7
  policy                   = templatefile("kms_key_policy.json", { region = data.aws_region.current.name, aws_account_id = data.aws_caller_identity.current.account_id })
  tags                     = var.tags
}

resource "aws_kms_alias" "this" {
  name          = "alias/cloudtrail"
  target_key_id = aws_kms_key.this.key_id
}

#tfsec:ignore:aws-s3-enable-bucket-logging
resource "aws_s3_bucket" "this" {
  bucket        = "${var.name}-cloudtrail"
  acl           = "private"
  force_destroy = false
  versioning {
    enabled = true
  }
  policy = templatefile("s3_bucket_policy.json", { bucket_name = "${var.name}-cloudtrail", aws_account_id = data.aws_caller_identity.current.account_id })

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.this.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/cloudtrail"
  retention_in_days = 14
  kms_key_id        = aws_kms_key.this.arn
  tags              = var.tags
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  ignore_public_acls      = true
  restrict_public_buckets = true
  block_public_acls       = true
  block_public_policy     = true
}

data "aws_iam_policy_document" "assume" {
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "cloudtrail" {
  statement {
    sid       = "AWSCloudTrailCreateLogStream"
    effect    = "Allow"
    resources = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${aws_cloudwatch_log_group.this.id}:log-stream:*"]
    actions   = ["logs:CreateLogStream"]
  }

  statement {
    sid       = "AWSCloudTrailPutLogEvents"
    effect    = "Allow"
    resources = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${aws_cloudwatch_log_group.this.id}:log-stream:*"]
    actions   = ["logs:PutLogEvents"]
  }
}

resource "aws_iam_role" "cloudtrail" {
  name               = "cloudtrail"
  assume_role_policy = data.aws_iam_policy_document.assume.json
}

resource "aws_iam_role_policy" "cloudtrail" {
  name   = "cloudtrail"
  role   = aws_iam_role.cloudtrail.id
  policy = data.aws_iam_policy_document.cloudtrail.json
}
