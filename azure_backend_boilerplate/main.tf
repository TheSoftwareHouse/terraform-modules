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
  sku_name                    = var.key_vault_sku_name
}

# Break circular dependency
resource "azapi_update_resource" "key_vault_network_acls" {
  count       = var.key_vault_sku_name == "premium" ? 1 : 0
  type        = "Microsoft.KeyVault/vaults@2022-07-01"
  resource_id = azurerm_key_vault.this.id

  body = jsonencode({
    properties = {
      networkAcls = {
        bypass              = "AzureServices"
        defaultAction       = "Deny"
        ipRules             = [for ip in concat(split(",", azurerm_linux_web_app.this.outbound_ip_addresses), var.key_vault_additional_ips) : { value = "${ip}/32" }]
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
  certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "ManageContacts", "ManageIssuers", "GetIssuers", "ListIssuers", "SetIssuers", "DeleteIssuers", "Purge"]
}

resource "azurerm_key_vault_access_policy" "app" {
  key_vault_id = azurerm_key_vault.this.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_linux_web_app.this.identity[0].principal_id

  secret_permissions = ["Get", "List"]
}

resource "azurerm_key_vault_secret" "this" {
  for_each = { for secret in var.secrets : secret.name => secret }
  name     = each.value.name
  value    = each.value.value

  key_vault_id = azurerm_key_vault.this.id

  lifecycle {
    ignore_changes = [
      value
    ]
  }

  depends_on = [azurerm_key_vault_access_policy.this]
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

  virtual_network_subnet_id = azurerm_subnet.this["snet-${var.project}-${var.environment}-app"].id

  site_config {
    container_registry_use_managed_identity = true

    http2_enabled = var.app_http2_enabled

    application_stack {
      docker_registry_url = "https://${azurerm_container_registry.this.login_server}"
      docker_image_name   = var.image_name_tag
    }

    dynamic "cors" {
      for_each = var.cors_origins != null ? [1] : []
      content {
        allowed_origins     = local.cors_origins.allowed_origins
        support_credentials = local.cors_origins.support_credentials
      }
    }
  }

  logs {
    detailed_error_messages = true
    failed_request_tracing  = true

    http_logs {
      file_system {
        retention_in_days = var.logs_retention_in_days
        retention_in_mb   = var.logs_retention_in_mb
      }
    }
  }

  identity {
    type = "SystemAssigned"
  }

  app_settings = merge({ "DOCKER_ENABLE_CI" = "true", "WEBSITE_PULL_IMAGE_OVER_VNET" = "true" },
    { for secrets in azurerm_key_vault_secret.this : replace(secrets.name, "-", "_") => "@Microsoft.KeyVault(SecretUri=${secrets.versionless_id}/)" },
    { for app_settings in var.app_settings : replace(app_settings.name, "-", "_") => app_settings.value },
  local.application_insights_env_variables)

  lifecycle {
    ignore_changes = [
      site_config[0].application_stack[0].docker_registry_url,
      site_config[0].application_stack[0].docker_image_name
    ]
  }
}

#################################################################
# CONTAINER REGISTRY
#################################################################
resource "azurerm_container_registry" "this" {
  name                = "cr${var.project}${var.environment}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  sku                 = var.container_registry_sku
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
  count               = var.enable_application_insights ? 1 : 0
  name                = "log-${var.project}-${var.environment}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  sku               = var.log_analytics_sku
  retention_in_days = var.log_analytics_workspace_retention_in_days
}

resource "azurerm_application_insights" "this" {
  count               = var.enable_application_insights ? 1 : 0
  name                = "ai-${var.project}-${var.environment}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  application_type    = "other"

  workspace_id = azurerm_log_analytics_workspace.this[0].id

  retention_in_days = var.application_insights_retention_in_days
}

#################################################################
# VIRTUAL NETWORK
#################################################################
resource "azurerm_virtual_network" "this" {
  name                = "vnet-${var.project}-${var.environment}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = var.vnet_address_space
}

#################################################################
# VIRTUAL NETWORK SUBNETS
#################################################################
resource "azurerm_subnet" "this" {
  for_each = { for subnet in concat(local.subnet_app, local.subnet_postgresql, local.subnet_mysql) : subnet.name => subnet }

  name                 = each.value.name
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = each.value.address_prefixes

  dynamic "delegation" {
    for_each = each.value.subnet_delegations != null ? each.value.subnet_delegations : []
    content {
      name = delegation.value.name
      service_delegation {
        name    = delegation.value.service_name
        actions = delegation.value.service_actions
      }
    }
  }

  service_endpoints = each.value.service_endpoints
}

#################################################################
# PRIVATE DNS ZONE
#################################################################
resource "azurerm_private_dns_zone" "this" {
  for_each            = { for dns_zone in concat(local.dns_zone_postgresql, local.dns_zone_mysql) : dns_zone.name => dns_zone }
  name                = each.value.name
  resource_group_name = azurerm_resource_group.this.name
}

#################################################################
# VIRTUAL NETWORK LINK
#################################################################
resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  for_each              = { for dns_zone in concat(local.dns_zone_postgresql, local.dns_zone_mysql) : dns_zone.name => dns_zone }
  name                  = "vdn-${each.value.type}-${var.project}-${var.environment}"
  private_dns_zone_name = azurerm_private_dns_zone.this[each.key].name
  resource_group_name   = azurerm_resource_group.this.name
  virtual_network_id    = azurerm_virtual_network.this.id
}

################################################################
# RANDOMS
################################################################
resource "random_string" "this" {
  length    = local.random_config.login_length
  special   = local.random_config.login_special
  min_lower = local.random_config.login_min_lower
}

resource "random_password" "this" {
  length           = local.random_config.pass_length
  special          = local.random_config.pass_special
  override_special = local.random_config.pass_override_special
}

################################################################
# POSTGRESQL FLEXIBLE SERVER
################################################################
resource "azurerm_postgresql_flexible_server" "this" {
  count               = var.enable_postgresql ? 1 : 0
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  name                   = "psql-${var.project}-${var.environment}"
  delegated_subnet_id    = azurerm_subnet.this["snet-${var.project}-${var.environment}-postgres"].id
  private_dns_zone_id    = azurerm_private_dns_zone.this["privatelink.postgres.database.azure.com"].id
  administrator_login    = var.psql_administrator_login == null ? random_string.this.result : var.psql_administrator_login
  administrator_password = var.psql_administrator_password == null ? random_password.this.result : var.psql_administrator_password

  backup_retention_days        = var.psql_backup_retention_days
  geo_redundant_backup_enabled = var.psql_geo_redundant_backup_enabled

  dynamic "high_availability" {
    for_each = var.psql_high_availability != null ? [var.psql_high_availability] : []
    content {
      mode                      = high_availability.value.mode
      standby_availability_zone = high_availability.value.standby_availability_zone
    }
  }

  dynamic "maintenance_window" {
    for_each = var.psql_maintenance_window != null ? [var.psql_maintenance_window] : []
    content {
      day_of_week  = maintenance_window.value.day_of_week
      start_hour   = maintenance_window.value.start_hour
      start_minute = maintenance_window.value.start_minute
    }
  }

  version    = var.psql_engine_version
  sku_name   = var.psql_sku_name
  storage_mb = var.psql_storage_mb
  zone       = var.psql_zone

  depends_on = [azurerm_subnet.this, azurerm_private_dns_zone.this, azurerm_private_dns_zone_virtual_network_link.this]
}

#################################################################
# MYSQL FLEXIBLE SERVER
#################################################################
resource "azurerm_mysql_flexible_server" "this" {
  count               = var.enable_mysql ? 1 : 0
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  name                   = "mysql-${var.project}-${var.environment}"
  delegated_subnet_id    = azurerm_subnet.this["snet-${var.project}-${var.environment}-mysql"].id
  private_dns_zone_id    = azurerm_private_dns_zone.this["privatelink.mysql.database.azure.com"].id
  administrator_login    = var.mysql_administrator_login == null ? random_string.this.result : var.mysql_administrator_login
  administrator_password = var.mysql_administrator_password == null ? random_password.this.result : var.mysql_administrator_password

  backup_retention_days        = var.mysql_backup_retention_days
  geo_redundant_backup_enabled = var.mysql_geo_redundant_backup_enabled

  dynamic "high_availability" {
    for_each = var.mysql_high_availability != null ? [var.mysql_high_availability] : []
    content {
      mode                      = high_availability.value.mode
      standby_availability_zone = high_availability.value.standby_availability_zone
    }
  }

  dynamic "maintenance_window" {
    for_each = var.mysql_maintenance_window != null ? [var.mysql_maintenance_window] : []
    content {
      day_of_week  = maintenance_window.value.day_of_week
      start_hour   = maintenance_window.value.start_hour
      start_minute = maintenance_window.value.start_minute
    }
  }

  dynamic "storage" {
    for_each = var.mysql_storage != null ? [var.mysql_storage] : []
    content {
      auto_grow_enabled = storage.auto_grow_enabled
      iops              = storage.iops
      size_gb           = storage.size_gb
    }
  }

  version  = var.mysql_engine_version
  sku_name = var.mysql_sku_name
  zone     = var.mysql_zone

  depends_on = [azurerm_subnet.this, azurerm_private_dns_zone.this, azurerm_private_dns_zone_virtual_network_link.this]
}

#################################################################
# REDIS
#################################################################
resource "azurerm_redis_cache" "this" {
  count               = var.enable_redis ? 1 : 0
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  name     = "redis-${var.project}-${var.environment}"
  capacity = var.redis_capacity
  family   = var.redis_family
  sku_name = var.redis_sku_name

  dynamic "redis_configuration" {
    for_each = var.redis_configuration != null ? [var.redis_configuration] : []
    content {
      aof_backup_enabled              = redis_configuration.value.aof_backup_enabled
      aof_storage_connection_string_0 = redis_configuration.value.aof_storage_connection_string_0
      aof_storage_connection_string_1 = redis_configuration.value.aof_storage_connection_string_1
      enable_authentication           = redis_configuration.value.enable_authentication
      maxmemory_reserved              = redis_configuration.value.maxmemory_reserved
      maxmemory_delta                 = redis_configuration.value.maxmemory_delta
      maxmemory_policy                = redis_configuration.value.maxmemory_policy
      maxfragmentationmemory_reserved = redis_configuration.value.maxfragmentationmemory_reserved
      rdb_backup_enabled              = redis_configuration.value.rdb_backup_enabled
      rdb_backup_frequency            = redis_configuration.value.rdb_backup_frequency
      rdb_backup_max_snapshot_count   = redis_configuration.value.rdb_backup_max_snapshot_count
      rdb_storage_connection_string   = redis_configuration.value.rdb_storage_connection_string
      notify_keyspace_events          = redis_configuration.value.notify_keyspace_events
    }
  }
}