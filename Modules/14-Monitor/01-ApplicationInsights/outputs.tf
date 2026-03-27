output "instrumentation_keys" {
  value = { for k, v in azurerm_application_insights.app_insights : k => v.instrumentation_key }
}

output "connection_strings" {
  value = { for k, v in azurerm_application_insights.app_insights : k => v.connection_string }
}

output "app_ids" {
  value = { for k, v in azurerm_application_insights.app_insights : k => v.app_id }
}
