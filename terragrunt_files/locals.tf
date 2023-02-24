locals {
  accounts = { for name, account in var.accounts : name => {
    id               = var.account_ids[name]
    modules          = account.modules
    file_name_prefix = "${lower(replace(replace(name, "/", ""), "/[\\s_]+/", "-"))}"
  } }

  management_account = tomap({ "${var.management_account_name}" = {
    id               = var.management_account_id
    modules          = lookup(var.management_account, "modules", [])
    file_name_prefix = "management"
  } })

  accounts_with_management = merge(local.accounts, local.management_account)

  accounts_path = join("", [
    "../../../../", # out of cache if terragrunt enabled
    var.accounts_path,
    substr(var.accounts_path, -1, -1) != "/" ? "/" : "" # add '/' if it is not at the end of the path
  ])

  warning_msg = "Created by Terraform as a local_file resource. DO NOT modify MANUALLY!"

  env_configs = [for account_name, account in local.accounts : {
    name     = format("%s_env", account.file_name_prefix)
    filename = format("%s/env.hcl", account.file_name_prefix)
    content = templatefile(format("%s/templates/env_config.tftpl", path.module), {
      warning_msg  = local.warning_msg
      account_id   = account.id
      account_name = account_name
    })
  }]

  default_module_configs = flatten([for account in local.accounts : [for tf_module in var.default_modules :
    {
      name     = format("%s_%s", account.file_name_prefix, tf_module.name)
      filename = format("%s%s/%s/terragrunt.hcl", account.file_name_prefix, length(tf_module.path) > 0 ? format("/%s", tf_module.path) : "", tf_module.name)
      content = templatefile(format("%s/templates/module_config.tftpl", path.module), {
        warning_msg              = local.warning_msg
        terragrunt_module_name   = tf_module.name
        terragrunt_templates_dir = var.templates_path
      })
    }
  ]])

  custom_module_configs = flatten([for account_name, account in local.accounts_with_management : [for tf_module in account.modules :
    {
      name     = format("%s_%s", account.file_name_prefix, tf_module.name)                                                                                   # alias_root!!!
      filename = format("%s%s/%s/terragrunt.hcl", account.file_name_prefix, length(tf_module.path) > 0 ? format("/%s", tf_module.path) : "", tf_module.name) # alias_root!!!
      content = templatefile(format("%s/templates/module_config.tftpl", path.module), {
        warning_msg              = local.warning_msg
        terragrunt_module_name   = tf_module.name
        terragrunt_templates_dir = var.templates_path
      })
    }
  ] if try(account.modules, null) != null])

  configs = { for config in concat(local.env_configs, local.default_module_configs, local.custom_module_configs) : config.name => {
    filename = config.filename
    content  = config.content
  } }

}


output "default_module_configs" {
  value = local.default_module_configs
}

output "custom_module_configs" {
  value = local.custom_module_configs
}

output "accounts" {
  value = local.accounts
}

output "management_account" {
  value = local.management_account
}

output "accounts_with_management" {
  value = local.accounts_with_management
}