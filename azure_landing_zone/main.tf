module "management_groups" {
  source            = "./modules/azurerm_management_groups"
  management_groups = var.management_groups
}

module "policies" {
  source   = "./modules/azurerm_policies"
  policies = var.policies

  depends_on = [
    module.management_groups.dummy_dependency
  ]
}

module "builtin_policies" {
  source           = "./modules/azurerm_builtin_policies"
  builtin_policies = var.builtin_policies

  depends_on = [
    module.management_groups.dummy_dependency
  ]
}

module "subscriptions_budgets" {
  source        = "./modules/azurerm_subscriptions_budgets"
  subscriptions = var.subscriptions

  depends_on = [
    module.management_groups.dummy_dependency
  ]
}
