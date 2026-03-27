output "ids" {
  value = { for k, v in azurerm_log_analytics_workspace.workspace : k => v.id }
}

output "primary_shared_keys" {
  value = { for k, v in azurerm_log_analytics_workspace.workspace : k => v.primary_shared_key }
}
