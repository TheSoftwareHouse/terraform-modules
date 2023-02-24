resource "aws_organizations_account" "this" {
  for_each          = var.accounts
  name              = each.key
  email             = each.value["email"]
  role_name         = var.organization_account_access_role_name
  parent_id         = lookup(var.ou_ids, each.value["ou"])
  close_on_deletion = each.value["close_on_deletion"]
  tags              = each.value["tags"]

  lifecycle {
    ignore_changes = [role_name]
  }
}