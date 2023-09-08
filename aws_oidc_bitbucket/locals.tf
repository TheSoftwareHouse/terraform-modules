locals {
  common = {
    tags = {
      created_by = "Terraform"
    }
  }

  bitbucket_oidc_policy = file("${path.module}/json/bitbucket_oidc_policy.json")
}