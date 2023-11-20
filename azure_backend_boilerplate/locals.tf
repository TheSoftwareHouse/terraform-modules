locals {
    application_insights_env_variables = var.enable_application_insights == false ? null : {
      "APPINSIGHTS_INSTRUMENTATIONKEY"        = azurerm_application_insights.this[0].instrumentation_key
      "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.this[0].connection_string
    }
}