output "app_service_name" {
  value = azurerm_app_service.app_service.name
}

output "app_service_default_hostname" {
  description = "The default hostname of the App Service (e.g., myapp.azurewebsites.net)"
  value       = azurerm_app_service.app_service.default_site_hostname
}
