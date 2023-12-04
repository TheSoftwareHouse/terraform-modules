resource "aws_organizations_policy" "this" {
  for_each      = var.policies

  name          = each.value["name"]
  content       = each.value["content"]
  description   = each.value["description"]
  type          = each.value["type"]
  tags          = each.value["tags"]
}

resource "aws_organizations_policy_attachment" "this" {
  for_each     = var.policies

  policy_id    = aws_organizations_policy.this[each.key].id
  target_id    = each.value["policy_target_id"]
}