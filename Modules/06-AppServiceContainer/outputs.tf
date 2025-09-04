output "outbound_ip_addresses" {
  value       = azurerm_linux_web_app.app_service_container.outbound_ip_addresses
  description = "A comma separated list of outbound IP addresses"
}

output "possible_outbound_ip_addresses" {
  value       = azurerm_linux_web_app.app_service_container.possible_outbound_ip_addresses
  description = "A comma separated list of outbound IP addresses. not all of which are necessarily in use"
}

output "site_credential" {
  value       = azurerm_linux_web_app.app_service_container.site_credential
  description = "The output of any site credentials"
  sensitive   = true
}

output "id" {
  value       = azurerm_linux_web_app.app_service_container.id
  description = "The ID of the App Service."
}

output "name" {
  value       = azurerm_linux_web_app.app_service_container.name
  description = "The name of the App Service."
}

output "web_identity" {
  description = "The managed identity block from the Function app"
  value       = azurerm_linux_web_app.app_service_container.identity
}