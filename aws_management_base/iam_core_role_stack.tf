resource "aws_cloudformation_stack" "iam_role" {
  name = var.name

  capabilities = [
    "CAPABILITY_NAMED_IAM"
  ]

  parameters = {
    RoleName = var.name
  }

  template_body = templatefile("iam_core_role_stack.template.json", { aws_trusted_entity = var.aws_trusted_entity })
}
