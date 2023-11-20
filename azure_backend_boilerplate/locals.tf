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
}