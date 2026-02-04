output "login_servers" {
  description = "ACR login servers"
  value       = { for k, v in azurerm_container_registry.acr : k => v.login_server }
}

output "admin_usernames" {
  description = "Admin usernames (if enabled)"
  value       = { for k, v in azurerm_container_registry.acr : k => v.admin_username }
}

output "admin_passwords" {
  description = "Admin passwords (if enabled)"
  value       = { for k, v in azurerm_container_registry.acr : k => v.admin_password }
  sensitive   = true
}
