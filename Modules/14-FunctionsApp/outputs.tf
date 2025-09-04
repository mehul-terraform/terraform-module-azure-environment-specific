output "id" {
  description = "Function app resource ID"
  value       = azurerm_linux_function_app.functionapp.id
}

output "function_app_default_hostname" {
  description = "Function app default hostname"
  value       = azurerm_linux_function_app.functionapp.default_hostname
}

output "function_app_identity_principal_id" {
  value = azurerm_linux_function_app.functionapp.identity[0].principal_id
}

