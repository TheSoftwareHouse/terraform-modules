resource "aws_organizations_account" "this" {
  for_each = var.accounts
  name     = each.key
  email    = each.value["email"]

  parent_id = each.value["organization_unit"]

  tags = var.tags

  # There is no AWS Organizations API for reading role_name
  lifecycle {
    ignore_changes = [role_name]
  }
}
