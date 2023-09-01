resource "aws_kms_alias" "this" {
  name          = var.name
  target_key_id = var.target_key_id
}
