output "organization_root_id" {
  value = aws_organizations_organization.this.roots[0].id
}

output "organization_units" {
  value = { for k, ou in aws_organizations_organizational_unit.this : k => ou.id }
}
