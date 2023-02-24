data "aws_caller_identity" "current" {}

data "aws_organizations_organization" "this" {
  provider = aws.management
}