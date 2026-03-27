resource "azurerm_log_analytics_workspace" "workspace" {
  for_each = var.workspaces

  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = each.value.sku
  retention_in_days   = each.value.retention_in_days
  tags                = merge(var.tags, each.value.tags)
}
