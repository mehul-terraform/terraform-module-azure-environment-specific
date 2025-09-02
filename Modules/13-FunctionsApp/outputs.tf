output "function_app_id" {
  description = "Function app resource ID"
  value       = azurerm_function_app.functionapp.id
}

output "function_app_default_hostname" {
  description = "Function app default hostname"
  value       = azurerm_function_app.functionapp.default_hostname
}

output "function_app_identity_principal_id" {
  description = "Function app managed identity principal ID"
  value       = azurerm_function_app.functionapp.identity.principal_id
}
