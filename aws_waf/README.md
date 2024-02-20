# AWS WAF

Creates Web Application Firewall resources and allows simple configuration of them. At this moment supporting:

- AWS Managed Rule Sets, by default it enables:
    - `AWSManagedRulesCommonRuleSet`
    - `AWSManagedRulesKnownBadInputsRuleSet`
    - `AWSManagedRulesAmazonIpReputationList`
    - `AWSManagedRulesAnonymousIpList`
- Blacklisting IP Sets
- Whitelisting IP Sets
- IP Rate Based Limiting
- Geoblocking
- Cloudwatch Dashboard

## Configuration

Configuration has been simplified, in order to share common values and configure them in one place, this module has been split into two parts, one being resources themselves and the other for using "core" module with provided inputs (that acts as a single source of truth). Configuration is quite simple and self-describing.
