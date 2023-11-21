resource "aws_iam_account_alias" "this" {
  account_alias = lower("${var.alias_prefix}-${var.account_alias}")
}
