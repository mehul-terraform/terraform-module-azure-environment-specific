output "app_service_id" {
  description = "Map of App Service IDs"
  value = {
    for key, app in azurerm_linux_web_app.app_service :
    key => app.id
  }
}

output "app_service_default_hostnames" {
  value = {
    for key, app in azurerm_linux_web_app.app_service :
    key => app.default_hostname
  }
}

