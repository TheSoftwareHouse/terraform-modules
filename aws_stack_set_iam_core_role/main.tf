resource "aws_cloudformation_stack_set" "iam_role" {
  name = var.name

  permission_model = "SERVICE_MANAGED"

  capabilities = [
    "CAPABILITY_NAMED_IAM"
  ]

  auto_deployment {
    enabled                          = true
    retain_stacks_on_account_removal = false
  }

  parameters = {
    RoleName = var.name
  }

  template_body = templatefile("template.json", { aws_trusted_entity = var.aws_trusted_entity })

  lifecycle {
    ignore_changes = [administration_role_arn]
  }
}

resource "aws_cloudformation_stack_set_instance" "global_iam_role" {
  deployment_targets {
    organizational_unit_ids = [var.aws_organization_root_id]
  }

  region         = var.region
  stack_set_name = aws_cloudformation_stack_set.iam_role.name
}
