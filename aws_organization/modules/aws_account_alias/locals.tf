locals {
  alias         = substr(var.alias, 0, length(var.alias_prefix) + 1) == format("%s-", var.alias_prefix) ? trimprefix(var.alias, format("%s-", var.alias_prefix)) : var.alias
  account_alias = lower(substr(join("-", compact([var.alias_prefix, local.alias, var.alias_suffix])), 0, 31))
}
