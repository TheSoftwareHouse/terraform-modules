resource "aws_organizations_organization" "this" {
  aws_service_access_principals = [
    "access-analyzer.amazonaws.com",
    "auditmanager.amazonaws.com",
    "aws-artifact-account-sync.amazonaws.com",
    "backup.amazonaws.com",
    "cloudtrail.amazonaws.com",
    "compute-optimizer.amazonaws.com",
    "config-multiaccountsetup.amazonaws.com",
    "config.amazonaws.com",
    "controltower.amazonaws.com",
    "ds.amazonaws.com",
    "fms.amazonaws.com",
    "guardduty.amazonaws.com",
    "license-manager.amazonaws.com",
    "license-manager.member-account.amazonaws.com",
    "macie.amazonaws.com",
    "member.org.stacksets.cloudformation.amazonaws.com",
    "ram.amazonaws.com",
    "reporting.trustedadvisor.amazonaws.com",
    "securityhub.amazonaws.com",
    "servicecatalog.amazonaws.com",
    "servicequotas.amazonaws.com",
    "ssm.amazonaws.com",
    "sso.amazonaws.com",
    "storage-lens.s3.amazonaws.com",
    "tagpolicies.tag.amazonaws.com",
  ]

  enabled_policy_types = [
    "AISERVICES_OPT_OUT_POLICY",
    "BACKUP_POLICY",
    "SERVICE_CONTROL_POLICY",
    "TAG_POLICY",
  ]

  feature_set = "ALL"
}

resource "aws_organizations_organizational_unit" "this" {
  for_each  = var.organization_units
  name      = each.key
  parent_id = each.value["parent_id"] != "root" ? each.value["parent_id"] : aws_organizations_organization.this.roots[0].id

  tags = var.tags

  depends_on = [
    aws_organizations_organization.this
  ]
}
