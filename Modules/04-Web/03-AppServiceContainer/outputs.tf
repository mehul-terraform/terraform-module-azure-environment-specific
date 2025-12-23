output "app_service_ids" {
  description = "Map of App Service IDs"
  value = {
    for key, app in azurerm_linux_web_app.app_service_container :
    key => app.id
  }
}

output "default_hostnames" {
  value = {
    for key, app in azurerm_linux_web_app.app_service_container :
    key => app.default_hostname
  }
}

