data "aws_caller_identity" "current" {}

resource "aws_inspector2_delegated_admin_account" "this" {
  count      = var.is_mgmt_account ? 1 : 0
  account_id = var.delegated_admin_account_id
}

resource "aws_inspector2_enabler" "this" {
  count          = var.is_mgmt_account ? 0 : 1
  account_ids    = [data.aws_caller_identity.current.account_id]
  resource_types = ["EC2", "ECR", "LAMBDA"]
}
