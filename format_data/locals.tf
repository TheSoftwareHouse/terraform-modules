locals {
  ## Common
  management_account = tomap({ "${var.management_account_name}" = var.management_account })
  accounts           = merge(local.management_account, var.accounts)

  list_of_account_providers = flatten([for account_key, account in local.accounts :
    [for provider_key, provider in account.shared_settings.providers : {
      account                     = account_key
      id                          = account.shared_settings.id
      identity_provider_role_name = format("%s_%s", provider_key, account.shared_settings.id)
      identity_provider_name      = provider_key
      identity_provider_type      = lookup(local.providers, provider_key)
      inputs                      = provider
    } if provider.enabled] if try(account.shared_settings, null) != null && try(account.shared_settings.providers, null) != null
  ])

  providers = { for name, provider in local.list_of_providers : name => provider.type }

  list_of_providers = var.identity_providers



  list_of_ids = distinct([for name, account in local.accounts : account.shared_settings.id if can(account.shared_settings.providers)])
  list_of_provider_roles = distinct([for account_provider in local.list_of_account_providers : {
    identity_provider_role_name = account_provider.identity_provider_role_name
    identity_provider_type      = account_provider.identity_provider_type
    identity_provider_name      = account_provider.identity_provider_name
  }])


  ## 1.1. Modules

  /* A list of module types with the names of the accounts in which they were used. */
  list_of_account_modules = flatten([for account_key, account in local.accounts :
    [for tf_module in account.modules : {
      account = account_key
      module  = tf_module.name
    }] if try(account.modules, null) != null
  ])


  ## 1.2. shared_settings

  ### 1.2.1. Providers

  /* A list of provider types. */
  list_of_provider_types = distinct([for key, provider in var.identity_providers : provider.type])

  /* A map of all account names grouped by provider type. */
  list_of_accounts_per_provider = { for provider_type in local.list_of_provider_types :
    provider_type => [for tf_module in local.list_of_account_modules : tf_module.account if tf_module.module == provider_type]
  }

  ### 'cicd_access_role'
  list_of_cicd_role_statements = [for provider in local.list_of_account_providers : {
    source_account_names     = local.list_of_accounts_per_provider[provider.identity_provider_type]
    source_role_name         = provider.identity_provider_role_name
    destination_account_name = provider.account
    statement_sid            = replace(provider.identity_provider_name, "/[^0-9a-zA-Z]/", "")
  } if length(local.list_of_accounts_per_provider[provider.identity_provider_type]) > 0]

  cicd_role_statements = { for name, account in local.accounts : name => { for statement in local.list_of_cicd_role_statements : statement.statement_sid => {
    role_name     = statement.source_role_name
    account_names = statement.source_account_names
  } if statement.destination_account_name == name } }

  ### 'bitbucket_oidc'
  bitbucket_oidc_type_name = "bitbucket_oidc"

  bitbucket_oidc_providers = { for i, j in local.list_of_providers : i => {
    identity_provider_url = j.identity_provider_url
    audience              = j.audience
    thumbprints           = j.thumbprints
  } if j.type == local.bitbucket_oidc_type_name }

  bitbucket_oidc_role_names = [for role in local.list_of_provider_roles : role if role.identity_provider_type == local.bitbucket_oidc_type_name] # filtrowanie ról dla modułu 'bitbucket_oidc'

  bitbucket_oidc_role_inputs = [for role in local.bitbucket_oidc_role_names : {
    role_name     = role.identity_provider_role_name
    provider_name = role.identity_provider_name
    inputs        = [for provider in local.list_of_account_providers : provider.inputs if provider.identity_provider_role_name == role.identity_provider_role_name]
  }]

  bitbucket_oidc_roles = { for i in local.bitbucket_oidc_role_inputs : i.role_name => {
    provider         = i.provider_name
    repository_uuids = distinct(flatten([for k in i.inputs : k.repository_uuids])) # k.enabled do usunięcia
  } }

  # S3 Backend
  backend_list_of_accounts = [for name, account in var.accounts : { # list of accounts with backend enabled
    backend_root_name = account.shared_settings.id
    account_name      = name
    create            = account.shared_settings.backend.enabled
  } if try(account.shared_settings.backend, null) != null]

  backend_list_of_backends = distinct([for account in local.backend_list_of_accounts : account.backend_root_name])

  backends = { for backend in local.backend_list_of_backends : backend => {
    create        = true
    account_names = flatten([for account in local.backend_list_of_accounts : account.account_name if account.backend_root_name == backend && account.create == true])
  } }
}