locals {
  default_session_duration = "PT1H"

  predefined_permission_sets = { for name, permission_set in var.permission_sets : name => {
    predefined_permission_set = permission_set.predefined_permission_set
    description               = permission_set.description != null ? permission_set.description : local.predefined_permission_set_definitions[permission_set.predefined_permission_set].description
    relay_state               = permission_set.relay_state
    session_duration          = permission_set.session_duration != null ? permission_set.session_duration : local.default_session_duration
  } if try(permission_set.predefined_permission_set, null) != null }

  custom_permission_sets = { for name, permission_set in var.permission_sets : name => {
    custom_permission_set = permission_set.custom_permission_set
    description           = permission_set.description
    relay_state           = permission_set.relay_state
    session_duration      = permission_set.session_duration != null ? permission_set.session_duration : local.default_session_duration
  } if try(permission_set.custom_permission_set, null) != null }

  predefined_permission_set_definitions = {
    "AdministratorAccess" = {
      description = "Provides full access to AWS services and resources."
    }
    "Billing" = {
      description = "Grants permissions for billing and cost management. This includes viewing account usage and viewing and modifying budgets and payment methods."
    }
    "DatabaseAdministrator" = {
      description = "Grants full access permissions to AWS services and actions required to set up and configure AWS database services."
    }
    "DataScientist" = {
      description = "Grants permissions to AWS data analytics services."
    }
    "NetworkAdministrator" = {
      description = "Grants full access permissions to AWS services and actions required to set up and configure AWS network resources."
    }
    "PowerUserAccess" = {
      description = "Provides full access to AWS services and resources, but does not allow management of Users and groups."
    }
    "SecurityAudit" = {
      description = "The security audit template grants access to read security configuration metadata. It is useful for software that audits the configuration of an AWS account."
    }
    "SupportUser" = {
      description = "This policy grants permissions to troubleshoot and resolve issues in an AWS account. This policy also enables the user to contact AWS support to create and manage cases."
    }
    "SystemAdministrator" = {
      description = "Grants full access permissions necessary for resources required for application and development operations."
    }
    "ViewOnlyAccess" = {
      description = "This policy grants permissions to view resources and basic metadata across all AWS services."
    }
  }
}