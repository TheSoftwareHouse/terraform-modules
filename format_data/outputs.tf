#### Identity Providers ####

### Common ###
output "list_of_account_providers" {
  value = local.list_of_account_providers
}

output "list_of_providers" {
  value = local.list_of_providers
}

output "list_of_provider_types" {
  value = local.list_of_provider_types
}

output "list_of_ids" {
  value = local.list_of_ids
}

output "list_of_provider_roles" {
  value = local.list_of_provider_roles
}

output "list_of_account_modules" {
  value = local.list_of_account_modules
}

output "list_of_accounts_per_provider" {
  value = local.list_of_accounts_per_provider
}

## Roles
output "list_of_cicd_role_statements" {
  value = local.list_of_cicd_role_statements
}

output "cicd_role_statements" {
  value = local.cicd_role_statements
}


## Modules

### 'bitbucket_oidc'
output "bitbucket_oidc_providers" {
  value = local.bitbucket_oidc_providers
}

output "bitbucket_oidc_roles" {
  value = local.bitbucket_oidc_roles
}



# Test
output "accounts" {
  value = local.accounts
}