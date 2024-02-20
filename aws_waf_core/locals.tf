locals {
  default_action = "allow"
  bad_user_agents = [
    "nintento",
    "playstation",
    "xbox"
  ]
  aws_managed_rule_groups = [
    {
      name        = "AWSManagedRulesCommonRuleSet"
      priority    = 20
      action      = "block"
      vendor_name = "AWS"
      version     = "Version_1.3"
      excluded_rule_names = [
        "CrossSiteScripting_COOKIE",
        "EC2MetaDataSSRF_COOKIE",
        "GenericLFI_BODY",
        "SizeRestrictions_BODY",
        "SizeRestrictions_Cookie_HEADER"
      ]
      alarm_configuration = null
    },
    {
      name                = "AWSManagedRulesKnownBadInputsRuleSet"
      priority            = 30
      action              = "block"
      vendor_name         = "AWS"
      version             = null
      excluded_rule_names = []
      alarm_configuration = null
    },
    {
      name                = "AWSManagedRulesAmazonIpReputationList"
      priority            = 31
      action              = "block"
      vendor_name         = "AWS"
      version             = null
      excluded_rule_names = []
      alarm_configuration = null
    },
    {
      name        = "AWSManagedRulesAnonymousIpList"
      priority    = 32
      action      = "block"
      vendor_name = "AWS"
      version     = null
      excluded_rule_names = [
        "HostingProviderIPList"
      ]
      alarm_configuration = null
    }
  ]
  ip_set_rules = {
    "whitelist-ip-v4" = {
      priority           = 10
      ip_address_version = "IPV4"
      action             = "allow"
      addresses = [
        "127.0.0.1"
      ]
      alarm_configuration = null
    }
    "whitelist-ip-v6" = {
      priority           = 11
      ip_address_version = "IPV6"
      action             = "allow"
      addresses = [
        "::1"
      ]
      alarm_configuration = null
    }
    "blacklist-ip-v4" = {
      priority           = 5
      ip_address_version = "IPV4"
      action             = "block"
      addresses = [
        "166.109.239.42", # DDoS Portal 23.11.2023
        "117.187.18.136", # DDoS Portal 23.11.2023
        "51.79.229.202",  # DDoS Portal 23.11.2023
        "139.162.52.57"   # DDoS Portal 23.11.2023
      ]
      alarm_configuration = null
    }
    "blacklist-ip-v6" = {
      priority            = 6
      ip_address_version  = "IPV6"
      action              = "block"
      addresses           = []
      alarm_configuration = null
    }
  }
  ip_rate_based_rules = {
    "generic" = {
      priority            = "15"
      action              = "block"
      limit               = 500
      alarm_configuration = null
    }
  }
  geo_match_rules = {
    "blacklist" = {
      priority = 15
      action   = "block"
      country_codes = [
        "AR", # Argentina
        "BD", # Bangladesh
        "BR", # Brazil
        "CN", # China
        "CO", # Colombia
        "EC", # Ecuador
        "ID", # Indonesia
        "IN", # India
        "IR", # Iran
        "MX", # Mexico
        "PH", # Philippines
        "RU", # Russian Federation
        "TH", # Thailand
        "TR", # Turkey
        "VN"  # Vietnam
      ]
      alarm_configuration = null
    }
  }
  cloudwatch = {
    enable_dashboard            = true
    enable_logging              = true
    enable_alarms_notifications = false
    alarms_config               = null
  }
}
