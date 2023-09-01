resource "aws_kms_key" "this" {
  description              = var.description
  key_usage                = var.key_usage
  is_enabled               = var.is_enabled
  multi_region             = var.multi_region
  customer_master_key_spec = var.customer_master_key_spec
  enable_key_rotation      = var.enable_key_rotation
  deletion_window_in_days  = var.deletion_window_in_days
  policy                   = var.policy
  tags                     = var.tags
}
