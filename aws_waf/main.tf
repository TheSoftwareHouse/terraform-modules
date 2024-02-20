module "aws_waf" {
  source = "../aws_waf_core"

  name              = var.name
  scope             = var.aws_scope
  default_action    = "allow"
  bad_user_agents   = local.blacklisted_user_agents
  ip_address_header = var.ip_address_header
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
    "blacklist-ip-v4" = {
      priority            = 5
      ip_address_version  = "IPV4"
      action              = "block"
      addresses           = local.blacklisted_ipv4_addresses
      alarm_configuration = null
    }
    "blacklist-ip-v6" = {
      priority            = 6
      ip_address_version  = "IPV6"
      action              = "block"
      addresses           = local.blacklisted_ipv6_addresses
      alarm_configuration = null
    }
    "whitelist-ip-v4" = {
      priority            = 10
      ip_address_version  = "IPV4"
      action              = "allow"
      addresses           = local.whitelisted_ipv4_addresses
      alarm_configuration = null
    }
    "whitelist-ip-v6" = {
      priority            = 11
      ip_address_version  = "IPV6"
      action              = "allow"
      addresses           = local.whitelisted_ipv6_addresses
      alarm_configuration = null
    }
  }
  ip_rate_based_rules = {
    "rate-limit" = {
      priority            = "15"
      action              = "block"
      limit               = local.aws_rate_limit
      alarm_configuration = null
    }
  }
  geo_match_rules = {
    "geo-blacklist" = {
      priority            = 16
      action              = local.aws_access_mode
      country_codes       = keys(local.blacklisted_countries)
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
