#################################################################
# GENERAL
#################################################################
variable "project" {
  type        = string
  description = "Project name"
}

variable "environment" {
  type        = string
  description = "Environment"
}

variable "location" {
  type        = string
  description = "Location where resources will reside"
}

#################################################################
# KEY VAULT
#################################################################

variable "key_vault_sku_name" {
  type        = string
  description = "(Optional) Sku name for the key vault"
  default     = "standard"
}

variable "secrets" {
  type = list(object({
    name  = string
    value = optional(string, "")
  }))
  description = "(Optional) List of secrets to add to the keyvault and as environment variables"
  default     = []
}

#################################################################
# APP SERVICE
#################################################################

variable "app_http2_enabled" {
  type        = bool
  description = "(Optional) Should the HTTP2 be enabled?)"
  default     = true
}

variable "image_name_tag" {
  type        = string
  description = "Image name and tag that will be used for automatic CI, should be consistent with container registry image name and tag"
}

variable "cors_origins" {
  type = object({
    allowed_origins     = list(string)
    support_credentials = bool
  })
  description = "Cors origins configuration"
  default     = null
}

variable "app_settings" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "(Optional) List of application settings"
  default     = []
}

variable "logs_retention_in_days" {
  type        = number
  description = "(Optional) Specifies the number of days to retain logs for. 0 means no retention. Defaults to 7."
  default     = 7
}

variable "logs_retention_in_mb" {
  type        = number
  description = "(Optional) Specifies the maximum size of the logs in MB. Defaults to 35."
  default     = 35
}

#################################################################
# CONTAINER REGISTRY
#################################################################
variable "container_registry_sku" {
  type        = string
  description = "(Optional) Sku for the container registry"
  default     = "Basic"
}

#################################################################
# LOG ANALYTICS, APPLICATION INSIGHTS, STORAGE ACCOUNT
#################################################################

variable "enable_application_insights" {
  type        = bool
  description = "(Optional) Weater to enable application insight for the application. Defaults to `false`."
  default     = false
}

variable "application_insights_retention_in_days" {
  type        = number
  description = "(Optional) Specifies the retention period in days. Possible values are 30, 60, 90, 120, 180, 270, 365, 550 or 730. Defaults to 30."
  default     = 30
}

variable "application_insights_CONFIGURATION_CONTENT" {
  type        = string
  description = "Sets up APPLICATIONINSIGHTS_CONFIGURATION_CONTENT environment variable"
  default     = ""
}

variable "log_analytics_sku" {
  type        = string
  description = "(Optional) Specifies the SKU of the Log Analytics Workspace. Possible values are Free, PerNode, Premium, Standard, Standalone, Unlimited, CapacityReservation, and PerGB2018 (new SKU as of 2018-04-03). Defaults to Free."
  default     = "PerGB2018"
}

variable "log_analytics_workspace_retention_in_days" {
  type        = number
  description = "(Optional) The workspace data retention in days. Possible values are either 7 (Free Tier only) or range between 30 and 730."
  default     = null
}

################################################################
#VIRTUAL NETWORK
################################################################

variable "vnet_address_space" {
  type        = list(string)
  description = "(Optional) The address space that is used the Virtual Network."
  default     = ["10.0.0.0/16"]
}

variable "subnet_app_address_prefixes" {
  type        = list(string)
  description = "(Optional) The address prefixes to use for the app subnet."
  default     = ["10.0.255.192/27"]
}

variable "subnet_postgresql_address_prefixes" {
  type        = list(string)
  description = "(Optional) The address prefixes to use for the PostgreSQL subnet."
  default     = ["10.0.255.224/27"]
}

variable "subnet_mysql_address_prefixes" {
  type        = list(string)
  description = "(Optional) The address prefixes to use for the MySQL subnet."
  default     = ["10.0.255.224/27"]
}

#################################################################
# POSTGRESQL FLEXIBLE SERVER
#################################################################

variable "enable_postgresql" {
  type        = bool
  description = "(Optional) Option to enable PostgreSQL Flexible Server. Defaults to `false`."
  default     = false
}

variable "psql_administrator_login" {
  type        = string
  description = "(Optional) Administrator login to be used for Flexible Server."
  default     = null
}

variable "psql_administrator_password" {
  type        = string
  description = "(Optional) Administrator password to be used for Flexible Server."
  default     = null
}

variable "psql_backup_retention_days" {
  type        = number
  description = "(Optional) The backup retention days for the Flexible Server. Possible values are between 7 and 35 days."
  default     = null
}

variable "psql_geo_redundant_backup_enabled" {
  type        = bool
  description = "(Optional) Is Geo-Redundant backup enabled on the Flexible Server. Defaults to false."
  default     = false
}

variable "psql_high_availability" {
  type = object({
    mode                      = string
    standby_availability_zone = optional(number, null)
  })
  description = "(Optional) High availability configuration for Flexible Server."
  default     = null
}

variable "psql_maintenance_window" {
  type = object({
    day_of_week  = optional(number, 0)
    start_hour   = optional(number, 0)
    start_minute = optional(number, 0)
  })
  description = "(Optional) Maintenance windows configuration for Flexible Server."
  default     = null
}

variable "psql_engine_version" {
  type        = number
  description = "The version of Flexible Server to use."
  default     = 14
}

variable "psql_sku_name" {
  type        = string
  description = "(Optional) The SKU Name for the Flexible Server. The name of the SKU, follows the tier + name pattern"
  default     = "B_Standard_B1ms"
}

variable "psql_zone" {
  type        = number
  description = "(Optional) Specifies the Availability Zone in which the Flexible Server should be located."
  default     = 3
}

variable "psql_storage_mb" {
  type        = string
  description = "(Optional) The max storage allowed for the PostgreSQL Flexible Server"
  default     = "32768"
}

#################################################################
# MYSQL FLEXIBLE SERVER
#################################################################

variable "enable_mysql" {
  type        = bool
  description = "(Optional) Option to enable MySQL Flexible Server. Defaults to `false`."
  default     = false
}

variable "mysql_administrator_login" {
  type        = string
  description = "(Optional) Administrator login to be used for Flexible Server."
  default     = null
}

variable "mysql_administrator_password" {
  type        = string
  description = "(Optional) Administrator password to be used for Flexible Server."
  default     = null
}

variable "mysql_backup_retention_days" {
  type        = number
  description = "(Optional) The backup retention days for the Flexible Server. Possible values are between 7 and 35 days."
  default     = null
}

variable "mysql_geo_redundant_backup_enabled" {
  type        = bool
  description = "(Optional) Is Geo-Redundant backup enabled on the Flexible Server. Defaults to false."
  default     = false
}

variable "mysql_high_availability" {
  type = object({
    mode                      = string
    standby_availability_zone = optional(number, null)
  })
  description = "(Optional) High availability configuration for Flexible Server."
  default     = null
}

variable "mysql_maintenance_window" {
  type = object({
    day_of_week  = optional(number, 0)
    start_hour   = optional(number, 0)
    start_minute = optional(number, 0)
  })
  description = "(Optional) Maintenance windows configuration for Flexible Server."
  default     = null
}

variable "mysql_engine_version" {
  type        = string
  description = "The version of Flexible Server to use."
  default     = "8.0.21"
}

variable "mysql_sku_name" {
  type        = string
  description = "(Required) The SKU Name for the Flexible Server. The name of the SKU, follows the tier + name pattern"
  default     = "B_Standard_B1ms"
}

variable "mysql_zone" {
  type        = number
  description = "(Optional) Specifies the Availability Zone in which the Flexible Server should be located."
  default     = 3
}

variable "mysql_storage" {
  type = object({
    auto_grow_enabled = optional(bool, null)
    iops              = optional(number, null)
    size_gb           = optional(number, null)
  })
  description = "(Optional) A storage configuration block for the MySQL Flexible Server."
  default     = null
}

#################################################################
# REDIS
#################################################################
variable "enable_redis" {
  type        = bool
  description = "(Optional) Option to enable Redis Cache. Defaults to `false`."
  default     = false
}

variable "redis_capacity" {
  type        = number
  description = "The size of the Redis cache to deploy."
  default     = 2
}

variable "redis_family" {
  type        = string
  description = "The SKU family/pricing group to use."
  default     = "C"
}

variable "redis_sku_name" {
  type        = string
  description = "(Optional) The SKU of Redis to use."
  default     = "Basic"
}

variable "redis_configuration" {
  type = object({
    aof_backup_enabled              = optional(bool, false)
    aof_storage_connection_string_0 = optional(string, null)
    aof_storage_connection_string_1 = optional(string, null)
    enable_authentication           = optional(bool, true)
    maxmemory_reserved              = optional(number, 10)
    maxmemory_delta                 = optional(number, 2)
    maxmemory_policy                = optional(string, "allkeys-lru")
    maxfragmentationmemory_reserved = optional(number, null)
    rdb_backup_enabled              = optional(bool, false)
    rdb_backup_frequency            = optional(number, null)
    rdb_backup_max_snapshot_count   = optional(number, null)
    rdb_storage_connection_string   = optional(string, null)
    notify_keyspace_events          = optional(string, null)
  })
  description = "(Optional) A configuration block for Redis."
  default     = null
}