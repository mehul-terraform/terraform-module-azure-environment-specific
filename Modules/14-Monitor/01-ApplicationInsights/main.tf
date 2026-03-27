resource "azurerm_application_insights" "app_insights" {
  for_each = var.app_insights

  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name
  workspace_id        = var.workspace_id
  application_type    = each.value.application_type
  tags                = merge(var.tags, each.value.tags)
}

resource "azurerm_monitor_diagnostic_setting" "app_insights" {
  for_each = var.app_insights

  name                       = "${each.value.name}-diag"
  target_resource_id         = azurerm_application_insights.app_insights[each.key].id
  log_analytics_workspace_id = var.workspace_id

  enabled_log {
    category_group = "allLogs"
  }

}
