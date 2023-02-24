data "aws_ssoadmin_instances" "this" {}

# Predefined permision set
data "aws_iam_policy" "predefined" {
  for_each = local.predefined_permission_set_definitions
  name     = each.key
}

resource "aws_ssoadmin_permission_set" "predefined" {
  for_each         = local.predefined_permission_sets
  name             = each.key
  description      = each.value["description"]
  relay_state      = each.value["relay_state"]
  session_duration = each.value["session_duration"]
  instance_arn     = tolist(data.aws_ssoadmin_instances.this.arns)[0]
}

resource "aws_ssoadmin_managed_policy_attachment" "predefined" {
  for_each           = local.predefined_permission_sets
  instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  managed_policy_arn = data.aws_iam_policy.predefined[each.value["predefined_permission_set"]].arn
  permission_set_arn = aws_ssoadmin_permission_set.predefined[each.key].arn
}

# Custom permission set
resource "aws_iam_policy" "custom" {
  for_each    = local.custom_permission_sets
  name        = format("%s_PermissionSet", each.key)
  description = each.value["description"]
  policy      = each.value["custom_permission_set"]
}

resource "aws_ssoadmin_permission_set" "custom" {
  for_each         = local.custom_permission_sets
  name             = each.key
  description      = each.value["description"]
  relay_state      = each.value["relay_state"]
  session_duration = each.value["session_duration"]
  instance_arn     = tolist(data.aws_ssoadmin_instances.this.arns)[0]
}

resource "aws_ssoadmin_customer_managed_policy_attachment" "custom" {
  for_each           = local.custom_permission_sets
  instance_arn       = aws_ssoadmin_permission_set.custom[each.key].instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.custom[each.key].arn
  customer_managed_policy_reference {
    name = aws_iam_policy.custom[each.key].name
    path = "/"
  }
}