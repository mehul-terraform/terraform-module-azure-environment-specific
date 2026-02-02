output "ids" {
  description = "Map of Linux Function App IDs"
  value       = { for k, v in azurerm_linux_function_app.this : k => v.id }
}

output "names" {
  description = "Map of Linux Function App names"
  value       = { for k, v in azurerm_linux_function_app.this : k => v.name }
}

output "default_hostnames" {
  description = "Map of Linux Function App default hostnames"
  value       = { for k, v in azurerm_linux_function_app.this : k => v.default_hostname }
}

output "service_plan_ids" {
  description = "Map of Service Plan IDs"
  value       = { for k, v in azurerm_service_plan.this : k => v.id }
}

output "storage_account_ids" {
  description = "Map of Storage Account IDs"
  value       = { for k, v in azurerm_storage_account.this : k => v.id }
}
