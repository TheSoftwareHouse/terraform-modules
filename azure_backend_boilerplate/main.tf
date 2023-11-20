#################################################################
# DATAS
#################################################################
data "azurerm_client_config" "current" {}

#################################################################
# RESOURCE GROUP
#################################################################
resource "azurerm_resource_group" "this" {
  name     = "rg-${var.project}-${var.environment}"
  location = var.location
}

#################################################################
# KEY VAULT
#################################################################
resource "azurerm_key_vault" "this" {
  name                        = "kv${var.project}${var.environment}"
  location                    = azurerm_resource_group.this.location
  resource_group_name         = azurerm_resource_group.this.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name = var.key_vault_sku_name
}

# Break circular dependency
resource "azapi_update_resource" "key_vault_network_acls" {
  count = var.key_vault_sku_name == "Premium" ? 1 : 0
  type = "Microsoft.KeyVault/vaults@2022-07-01"
  resource_id = azurerm_key_vault.this.id

  body = jsonencode({
    properties = {
      networkAcls = {
        bypass                     = "AzureServices"
        defaultAction = "Deny"
        ipRules = [for ip in concat(split(",", azurerm_linux_web_app.this.outbound_ip_addresses), var.key_vault_additional_ips) : { value = "${ip}/32" }]
        virtualNetworkRules = []
      }
    }
  })
}

resource "azurerm_key_vault_access_policy" "this" {
  key_vault_id = azurerm_key_vault.this.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions         = ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"]
  secret_permissions      = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"]
  storage_permissions     = ["Backup", "Delete", "DeleteSAS", "Get", "GetSAS", "List", "ListSAS", "Purge", "Recover", "RegenerateKey", "Restore", "Set", "SetSAS", "Update"]
}

resource "azurerm_key_vault_access_policy" "app" {
  key_vault_id = azurerm_key_vault.this.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_linux_web_app.this.identity[0].principal_id

  secret_permissions      = ["Get", "List"]
}

resource "azurerm_key_vault_secret" "this" {
  for_each     = { for secret in var.secrets : secret.name => secret }
  name         = each.value.name
  value        = each.value.value

  key_vault_id    = azurerm_key_vault.this.id

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

#################################################################
# APP SERVICE
#################################################################
resource "azurerm_service_plan" "this" {
  name                = "sp-${var.project}-${var.environment}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "this" {
  name                = "app-${var.project}-${var.environment}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_service_plan.this.location
  service_plan_id     = azurerm_service_plan.this.id

  https_only = true
  
  #virtual_network_subnet_id = local.virtual_network_subnet_id

  site_config {
    container_registry_use_managed_identity = true

    http2_enabled = var.app_http2_enabled #true

    application_stack {
      docker_image_name = "${azurerm_container_registry.this.login_server}/${var.image_name_tag}"
    }

    dynamic "cors" {
      for_each = var.cors_origins != null ? [1] : []
      content {
        allowed_origins     = local.cors_origins.allowed_origins
        support_credentials = local.cors_origins.support_credentials
      }
    }
  }

  identity {
    type = "SystemAssigned"
  }

  app_settings = merge({ "DOCKER_ENABLE_CI" = "true"}, 
  { for secrets in azurerm_key_vault_secret.this : replace(secrets.name, "-", "_") => "@Microsoft.KeyVault(SecretUri=${secrets.versionless_id}/)" },
  { for app_settings in var.app_settings : replace(app_settings.name,"-","_") => app_settings.value},
  local.application_insights_env_variables)
}

#################################################################
# CONTAINER REGISTRY
#################################################################
resource "azurerm_container_registry" "this" {
  name                = "cr${var.project}${var.environment}" #"acrexamplekd"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  sku                 = var.container_registry_sku #"Basic"
  admin_enabled       = false
}

resource "azurerm_role_assignment" "this" {
  scope                = azurerm_container_registry.this.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_linux_web_app.this.identity[0].principal_id
}

#################################################################
# LOG ANALYTICS, APPLICATION INSIGHTS, STORAGE ACCOUNT
#################################################################
resource "azurerm_log_analytics_workspace" "this" {
    count = var.enable_application_insights ? 1 : 0
    name = "log-${var.project}-${var.environment}"
    resource_group_name = azurerm_resource_group.this.name
    location = azurerm_resource_group.this.location

    sku = var.log_analytics_sku
    retention_in_days = var.log_analytics_workspace_retention_in_days
}

resource "azurerm_application_insights" "this" {
  count = var.enable_application_insights ? 1 : 0
  name                = "ai-${var.project}-${var.environment}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  application_type    = "other"

  workspace_id = azurerm_log_analytics_workspace.this[0].id

  retention_in_days = var.application_insights_retention_in_days
}

# Break circular dependency
resource "azapi_update_resource" "application_insights_tags" {
  count = var.enable_application_insights ? 1 : 0
  type = "Microsoft.Insights/components@2020-02-02"
  resource_id = azurerm_application_insights.this[0].id

  body = jsonencode({
      tags = {
        "hidden-link:${azurerm_linux_web_app.this.id}" = "Resource"
      }
  })
}

#################################################################
# VIRTUAL NETWORK
#################################################################

#################################################################
# REDIS
#################################################################