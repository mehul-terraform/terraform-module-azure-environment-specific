output "app_service_ids" {
  description = "Map of Windows App Service IDs"
  value = {
    for key, app in azurerm_windows_web_app.app_service :
    key => app.id
  }
}

output "default_hostnames" {
  value = {
    for key, app in azurerm_windows_web_app.app_service :
    key => app.default_hostname
  }
}

output "identity_principal_id" {
  description = "Map of App Service system-assigned identity principal IDs"
  value = {
    for key, app in azurerm_windows_web_app.app_service :
    key => app.identity[0].principal_id
  }
}
