resource "aws_iam_role" "this" {
  name                 = var.name
  description          = var.description
  assume_role_policy   = var.assume_role_policy
  managed_policy_arns  = var.managed_policy_arns
  max_session_duration = var.max_session_duration
  dynamic "inline_policy" {
    for_each = var.inline_policies
    content {
      name   = inline_policy.value["name"]
      policy = inline_policy.value["policy"]
    }
  }
  tags = var.tags
}
