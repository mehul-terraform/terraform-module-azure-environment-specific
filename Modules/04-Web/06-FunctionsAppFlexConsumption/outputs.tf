output "id" {
  description = "Function app resource ID"
  value       = azurerm_function_app_flex_consumption.function_app.id
}

output "function_app_default_hostname" {
  description = "Function app default hostname"
  value       = azurerm_function_app_flex_consumption.function_app.default_hostname
}


#output "function_app_identity_principal_id" {
#  value = azurerm_function_app_flex_consumption.function_app.identity[0].principal_id
#}

