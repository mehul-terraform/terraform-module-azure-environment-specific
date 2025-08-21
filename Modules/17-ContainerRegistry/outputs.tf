output "login_server" {
  description = "ACR login server"
  value       = azurerm_container_registry.acr.login_server
}

output "admin_username" {
  description = "Admin username (if enabled)"
  value       = azurerm_container_registry.acr.admin_username
}

output "admin_password" {
  description = "Admin password (if enabled)"
  value       = azurerm_container_registry.acr.admin_password
  sensitive   = true
}
