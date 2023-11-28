locals {
  application_insights_env_variables = var.enable_application_insights == false ? null : {
    "APPINSIGHTS_INSTRUMENTATIONKEY"                  = azurerm_application_insights.this[0].instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING"           = azurerm_application_insights.this[0].connection_string
    "APPINSIGHTS_PROFILERFEATURE_VERSION"             = "1.0.0"
    "APPINSIGHTS_SNAPSHOTFEATURE_VERSION"             = "1.0.0"
    "ApplicationInsightsAgent_EXTENSION_VERSION"      = "~3"
    "XDT_MicrosoftApplicationInsights_BaseExtensions" = "disabled"
    "DiagnosticServices_EXTENSION_VERSION"            = "~3"
    "InstrumentationEngine_EXTENSION_VERSION"         = "disabled"
    "SnapshotDebugger_EXTENSION_VERSION"              = "disabled"
    "XDT_MicrosoftApplicationInsights_Mode"           = "recommended"
    "XDT_MicrosoftApplicationInsights_PreemptSdk"     = "disabled"
    "APPLICATIONINSIGHTS_CONFIGURATION_CONTENT"       = var.application_insights_CONFIGURATION_CONTENT
  }

  subnet_app = [
    {
      name             = "snet-${var.project}-${var.environment}-app"
      address_prefixes = ["10.0.255.192/27"]
      subnet_delegations = [
        {
          name         = "appService"
          service_name = "Microsoft.Web/serverFarms"
          service_actions = [
            "Microsoft.Network/virtualNetworks/subnets/action"
          ]
        }
      ]
      service_endpoints = []
    }
  ]

  subnet_postgresql = var.enable_postgresql == false ? [] : [
    {
      name             = "snet-${var.project}-${var.environment}-postgres"
      address_prefixes = ["10.0.255.224/27"]
      subnet_delegations = [
        {
          name         = "flexibleServer"
          service_name = "Microsoft.DBforPostgreSQL/flexibleServers"
          service_actions = [
            "Microsoft.Network/virtualNetworks/subnets/join/action"
          ]
        }
      ]
      service_endpoints = ["Microsoft.Storage"]
    }
  ]

  subnet_mysql = var.enable_mysql == false ? [] : [
    {
      name             = "snet-${var.project}-${var.environment}-mysql"
      address_prefixes = ["10.0.255.224/27"]
      subnet_delegations = [
        {
          name         = "flexibleServer"
          service_name = "Microsoft.DBforMySQL/flexibleServers"
          service_actions = [
            "Microsoft.Network/virtualNetworks/subnets/join/action"
          ]
        }
      ]
      service_endpoints = ["Microsoft.Storage"]
    }
  ]

  dns_zone_postgresql = var.enable_postgresql == false ? [] : [
    {
      name = "privatelink.postgres.database.azure.com"
      type = "psql"
    }
  ]

  dns_zone_mysql = var.enable_mysql == false ? [] : [
    {
      name = "privatelink.mysql.database.azure.com"
      type = "mysql"
    }
  ]

  random_config = {
    login_length          = 16
    login_min_lower       = 8
    pass_length           = 24
    pass_override_special = "!#$%&*()-_=+[]{}<>:?"
    login_special         = false
    pass_special          = true
  }
}