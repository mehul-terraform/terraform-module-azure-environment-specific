output "id" {
  value = azurerm_linux_web_app.app_service_container.id
}

output "default_hostname" {
  description = "The default hostname of the App Service (e.g., myapp.azurewebsites.net)"
  value       = azurerm_linux_web_app.app_service_container.default_hostname
}