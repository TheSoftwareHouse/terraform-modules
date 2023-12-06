# Azure Backend Boilerplate

### Purpose

This module is a boilerplate for hosting a backend application on Azure. It's intended to be used as a starting point. This code can create the following resources:
- Resource Group
- Key Vault
- App Service Plan with App Service
- Container Registry
- Log Analytics Workspace with Application Insights (Optional)
- Postgres Database (Optional)
- MySQL Database (Optional)
- Redis Cache (Optional)

### How to use

This example, creates a standard config with Postgres Database.
```hcl
module "backend-boilerplate" {
  source = "./azure_backend_boilerplate"

  project = "helloworld"
  environment = "prod"
  location = "northeurope"

  secrets = [
    {
        name = "POSTGRESQL-USER"
    },
    {
        name = "POSTGRESQL-PASSWORD"
    },
    {
        name = "POSTGRESQL-SERVER"
    }
  ]
  
  enable_postgresql = true

  image_name_tag = "helloworld:prod"
}
```

Key remarks:
- To add a environeent variable to App Service, add it to `secrets` variable. It will be added to Key Vault and referenced in the App Service configuration.
- Both MySql and Postgres are setup within a VNet and you can access it only from the virtual network itself.
- `image_name_tag` is used to setup an automatic CI between the Container Registry and App Service.

For list of all available variables and their defaults, check the below table.


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.5.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=3.80 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >=3.5.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >=3.80 |
| <a name="provider_random"></a> [random](#provider\_random) | >=3.5.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_application_insights.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) | resource |
| [azurerm_container_registry.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry) | resource |
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_access_policy.app](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_secret.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_linux_web_app.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app) | resource |
| [azurerm_log_analytics_workspace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_mysql_flexible_server.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server) | resource |
| [azurerm_postgresql_flexible_server.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server) | resource |
| [azurerm_private_dns_zone.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_redis_cache.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/redis_cache) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_service_plan.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan) | resource |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [random_password.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_string.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_http2_enabled"></a> [app\_http2\_enabled](#input\_app\_http2\_enabled) | (Optional) Should the HTTP2 be enabled?) | `bool` | `true` | no |
| <a name="input_app_settings"></a> [app\_settings](#input\_app\_settings) | (Optional) List of application settings | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `[]` | no |
| <a name="input_application_insights_CONFIGURATION_CONTENT"></a> [application\_insights\_CONFIGURATION\_CONTENT](#input\_application\_insights\_CONFIGURATION\_CONTENT) | Sets up APPLICATIONINSIGHTS\_CONFIGURATION\_CONTENT environment variable | `string` | `""` | no |
| <a name="input_application_insights_retention_in_days"></a> [application\_insights\_retention\_in\_days](#input\_application\_insights\_retention\_in\_days) | (Optional) Specifies the retention period in days. Possible values are 30, 60, 90, 120, 180, 270, 365, 550 or 730. Defaults to 30. | `number` | `30` | no |
| <a name="input_container_registry_sku"></a> [container\_registry\_sku](#input\_container\_registry\_sku) | (Optional) Sku for the container registry | `string` | `"Basic"` | no |
| <a name="input_cors_origins"></a> [cors\_origins](#input\_cors\_origins) | Cors origins configuration | <pre>object({<br>    allowed_origins     = list(string)<br>    support_credentials = bool<br>  })</pre> | `null` | no |
| <a name="input_enable_application_insights"></a> [enable\_application\_insights](#input\_enable\_application\_insights) | (Optional) Weater to enable application insight for the application. Defaults to `false`. | `bool` | `false` | no |
| <a name="input_enable_mysql"></a> [enable\_mysql](#input\_enable\_mysql) | (Optional) Option to enable MySQL Flexible Server. Defaults to `false`. | `bool` | `false` | no |
| <a name="input_enable_postgresql"></a> [enable\_postgresql](#input\_enable\_postgresql) | (Optional) Option to enable PostgreSQL Flexible Server. Defaults to `false`. | `bool` | `false` | no |
| <a name="input_enable_redis"></a> [enable\_redis](#input\_enable\_redis) | (Optional) Option to enable Redis Cache. Defaults to `false`. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment | `string` | n/a | yes |
| <a name="input_image_name_tag"></a> [image\_name\_tag](#input\_image\_name\_tag) | Image name and tag that will be used for automatic CI, should be consistent with container registry image name and tag | `string` | n/a | yes |
| <a name="input_key_vault_sku_name"></a> [key\_vault\_sku\_name](#input\_key\_vault\_sku\_name) | (Optional) Sku name for the key vault | `string` | `"standard"` | no |
| <a name="input_location"></a> [location](#input\_location) | Location where resources will reside | `string` | n/a | yes |
| <a name="input_log_analytics_sku"></a> [log\_analytics\_sku](#input\_log\_analytics\_sku) | (Optional) Specifies the SKU of the Log Analytics Workspace. Possible values are Free, PerNode, Premium, Standard, Standalone, Unlimited, CapacityReservation, and PerGB2018 (new SKU as of 2018-04-03). Defaults to Free. | `string` | `"PerGB2018"` | no |
| <a name="input_log_analytics_workspace_retention_in_days"></a> [log\_analytics\_workspace\_retention\_in\_days](#input\_log\_analytics\_workspace\_retention\_in\_days) | (Optional) The workspace data retention in days. Possible values are either 7 (Free Tier only) or range between 30 and 730. | `number` | `null` | no |
| <a name="input_logs_retention_in_days"></a> [logs\_retention\_in\_days](#input\_logs\_retention\_in\_days) | (Optional) Specifies the number of days to retain logs for. 0 means no retention. Defaults to 7. | `number` | `7` | no |
| <a name="input_logs_retention_in_mb"></a> [logs\_retention\_in\_mb](#input\_logs\_retention\_in\_mb) | (Optional) Specifies the maximum size of the logs in MB. Defaults to 35. | `number` | `35` | no |
| <a name="input_mysql_administrator_login"></a> [mysql\_administrator\_login](#input\_mysql\_administrator\_login) | (Optional) Administrator login to be used for Flexible Server. | `string` | `null` | no |
| <a name="input_mysql_administrator_password"></a> [mysql\_administrator\_password](#input\_mysql\_administrator\_password) | (Optional) Administrator password to be used for Flexible Server. | `string` | `null` | no |
| <a name="input_mysql_backup_retention_days"></a> [mysql\_backup\_retention\_days](#input\_mysql\_backup\_retention\_days) | (Optional) The backup retention days for the Flexible Server. Possible values are between 7 and 35 days. | `number` | `null` | no |
| <a name="input_mysql_engine_version"></a> [mysql\_engine\_version](#input\_mysql\_engine\_version) | The version of Flexible Server to use. | `string` | `"8.0.21"` | no |
| <a name="input_mysql_geo_redundant_backup_enabled"></a> [mysql\_geo\_redundant\_backup\_enabled](#input\_mysql\_geo\_redundant\_backup\_enabled) | (Optional) Is Geo-Redundant backup enabled on the Flexible Server. Defaults to false. | `bool` | `false` | no |
| <a name="input_mysql_high_availability"></a> [mysql\_high\_availability](#input\_mysql\_high\_availability) | (Optional) High availability configuration for Flexible Server. | <pre>object({<br>    mode                      = string<br>    standby_availability_zone = optional(number, null)<br>  })</pre> | `null` | no |
| <a name="input_mysql_maintenance_window"></a> [mysql\_maintenance\_window](#input\_mysql\_maintenance\_window) | (Optional) Maintenance windows configuration for Flexible Server. | <pre>object({<br>    day_of_week  = optional(number, 0)<br>    start_hour   = optional(number, 0)<br>    start_minute = optional(number, 0)<br>  })</pre> | `null` | no |
| <a name="input_mysql_sku_name"></a> [mysql\_sku\_name](#input\_mysql\_sku\_name) | (Required) The SKU Name for the Flexible Server. The name of the SKU, follows the tier + name pattern | `string` | `"B_Standard_B1ms"` | no |
| <a name="input_mysql_storage"></a> [mysql\_storage](#input\_mysql\_storage) | (Optional) A storage configuration block for the MySQL Flexible Server. | <pre>object({<br>    auto_grow_enabled = optional(bool, null)<br>    iops              = optional(number, null)<br>    size_gb           = optional(number, null)<br>  })</pre> | `null` | no |
| <a name="input_mysql_zone"></a> [mysql\_zone](#input\_mysql\_zone) | (Optional) Specifies the Availability Zone in which the Flexible Server should be located. | `number` | `3` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name | `string` | n/a | yes |
| <a name="input_psql_administrator_login"></a> [psql\_administrator\_login](#input\_psql\_administrator\_login) | (Optional) Administrator login to be used for Flexible Server. | `string` | `null` | no |
| <a name="input_psql_administrator_password"></a> [psql\_administrator\_password](#input\_psql\_administrator\_password) | (Optional) Administrator password to be used for Flexible Server. | `string` | `null` | no |
| <a name="input_psql_backup_retention_days"></a> [psql\_backup\_retention\_days](#input\_psql\_backup\_retention\_days) | (Optional) The backup retention days for the Flexible Server. Possible values are between 7 and 35 days. | `number` | `null` | no |
| <a name="input_psql_engine_version"></a> [psql\_engine\_version](#input\_psql\_engine\_version) | The version of Flexible Server to use. | `number` | `14` | no |
| <a name="input_psql_geo_redundant_backup_enabled"></a> [psql\_geo\_redundant\_backup\_enabled](#input\_psql\_geo\_redundant\_backup\_enabled) | (Optional) Is Geo-Redundant backup enabled on the Flexible Server. Defaults to false. | `bool` | `false` | no |
| <a name="input_psql_high_availability"></a> [psql\_high\_availability](#input\_psql\_high\_availability) | (Optional) High availability configuration for Flexible Server. | <pre>object({<br>    mode                      = string<br>    standby_availability_zone = optional(number, null)<br>  })</pre> | `null` | no |
| <a name="input_psql_maintenance_window"></a> [psql\_maintenance\_window](#input\_psql\_maintenance\_window) | (Optional) Maintenance windows configuration for Flexible Server. | <pre>object({<br>    day_of_week  = optional(number, 0)<br>    start_hour   = optional(number, 0)<br>    start_minute = optional(number, 0)<br>  })</pre> | `null` | no |
| <a name="input_psql_sku_name"></a> [psql\_sku\_name](#input\_psql\_sku\_name) | (Optional) The SKU Name for the Flexible Server. The name of the SKU, follows the tier + name pattern | `string` | `"B_Standard_B1ms"` | no |
| <a name="input_psql_storage_mb"></a> [psql\_storage\_mb](#input\_psql\_storage\_mb) | (Optional) The max storage allowed for the PostgreSQL Flexible Server | `string` | `"32768"` | no |
| <a name="input_psql_zone"></a> [psql\_zone](#input\_psql\_zone) | (Optional) Specifies the Availability Zone in which the Flexible Server should be located. | `number` | `3` | no |
| <a name="input_redis_capacity"></a> [redis\_capacity](#input\_redis\_capacity) | The size of the Redis cache to deploy. | `number` | `2` | no |
| <a name="input_redis_configuration"></a> [redis\_configuration](#input\_redis\_configuration) | (Optional) A configuration block for Redis. | <pre>object({<br>    aof_backup_enabled              = optional(bool, false)<br>    aof_storage_connection_string_0 = optional(string, null)<br>    aof_storage_connection_string_1 = optional(string, null)<br>    enable_authentication           = optional(bool, true)<br>    maxmemory_reserved              = optional(number, 10)<br>    maxmemory_delta                 = optional(number, 2)<br>    maxmemory_policy                = optional(string, "allkeys-lru")<br>    maxfragmentationmemory_reserved = optional(number, null)<br>    rdb_backup_enabled              = optional(bool, false)<br>    rdb_backup_frequency            = optional(number, null)<br>    rdb_backup_max_snapshot_count   = optional(number, null)<br>    rdb_storage_connection_string   = optional(string, null)<br>    notify_keyspace_events          = optional(string, null)<br>  })</pre> | `null` | no |
| <a name="input_redis_family"></a> [redis\_family](#input\_redis\_family) | The SKU family/pricing group to use. | `string` | `"C"` | no |
| <a name="input_redis_sku_name"></a> [redis\_sku\_name](#input\_redis\_sku\_name) | (Optional) The SKU of Redis to use. | `string` | `"Basic"` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | (Optional) List of secrets to add to the keyvault and as environment variables | <pre>list(object({<br>    name  = string<br>    value = optional(string, "")<br>  }))</pre> | `[]` | no |
| <a name="input_subnet_app_address_prefixes"></a> [subnet\_app\_address\_prefixes](#input\_subnet\_app\_address\_prefixes) | (Optional) The address prefixes to use for the app subnet. | `list(string)` | <pre>[<br>  "10.0.255.192/27"<br>]</pre> | no |
| <a name="input_subnet_mysql_address_prefixes"></a> [subnet\_mysql\_address\_prefixes](#input\_subnet\_mysql\_address\_prefixes) | (Optional) The address prefixes to use for the MySQL subnet. | `list(string)` | <pre>[<br>  "10.0.255.224/27"<br>]</pre> | no |
| <a name="input_subnet_postgresql_address_prefixes"></a> [subnet\_postgresql\_address\_prefixes](#input\_subnet\_postgresql\_address\_prefixes) | (Optional) The address prefixes to use for the PostgreSQL subnet. | `list(string)` | <pre>[<br>  "10.0.255.224/27"<br>]</pre> | no |
| <a name="input_vnet_address_space"></a> [vnet\_address\_space](#input\_vnet\_address\_space) | (Optional) The address space that is used the Virtual Network. | `list(string)` | <pre>[<br>  "10.0.0.0/16"<br>]</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->