#################################################################
# GENERAL
#################################################################
variable "project" {
  type = string
  description = "Project name"
}

variable "environment" {
  type = string
  description = "Environment"
}

variable "location" {
  type = string
  description = "Location where resources will reside"
}

#################################################################
# KEY VAULT
#################################################################

variable "key_vault_sku_name" {
  type = string
  description = "(Optional) Sku name for the key vault"
  default = "premium"
}

variable "key_vault_additional_ips" {
  type = list(string)
  description = "(Optional) List of additional IPs to grant access to the Key Vault"
  default = []
}

variable "secrets" {
    type = list(object({
        name = string
        value = optional(string, "")
    }))
    description = "(Optional) List of secrets to add to the keyvault and as environment variables"
    default = []
}

#################################################################
# APP SERVICE
#################################################################

variable "app_http2_enabled" {
  type = bool
  description = "(Optional) Should the HTTP2 be enabled?)"
  default = true
}

variable "image_name_tag" {
  type = string
  description = "Image name and tag that will be used for automatic CI, should be consistent with container registry image name and tag"
}

variable "cors_origins" {
  type = object({
    allowed_origins = list(string)
    support_credentials = bool
  })
  description = "Cors origins configuration"
  default = null
}

variable "app_settings" {
  type = list(object({
    name = string
    value = string
  }))
  description = "(Optional) List of application settings"
  default = []
}

#################################################################
# CONTAINER REGISTRY
#################################################################
variable "container_registry_sku" {
  type = string
  description = "(Optional) Sku for the container registry"
  default = "Basic"
}

#################################################################
# LOG ANALYTICS, APPLICATION INSIGHTS, STORAGE ACCOUNT
#################################################################

variable "enable_application_insights" {
  type = bool
  description = "(Optional) Weater to enable application insight for the application. Defaults to `false`."
  default = false
}

variable "application_insights_retention_in_days" {
  type = number
  description = "(Optional) Specifies the retention period in days. Possible values are 30, 60, 90, 120, 180, 270, 365, 550 or 730. Defaults to 30."
  default = 30
}

variable "log_analytics_sku" {
  type = string
  description = "(Optional) Specifies the SKU of the Log Analytics Workspace. Possible values are Free, PerNode, Premium, Standard, Standalone, Unlimited, CapacityReservation, and PerGB2018 (new SKU as of 2018-04-03). Defaults to Free."
  default = "Free"
}

variable "log_analytics_workspace_retention_in_days" {
  type = number
  description = "(Optional) The workspace data retention in days. Possible values are either 7 (Free Tier only) or range between 30 and 730."
  default = null
}

#################################################################
# VIRTUAL NETWORK
#################################################################

#################################################################
# REDIS
#################################################################s