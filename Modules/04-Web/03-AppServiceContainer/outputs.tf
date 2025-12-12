output "app_service_container_id" {
  description = "Map of App Service IDs"
  value = {
    for key, app in azurerm_linux_web_app.app_service_container :
    key => app.id
  }
}

output "app_service_container_default_hostnames" {
  value = {
    for key, app in azurerm_linux_web_app.app_service_container :
    key => app.default_hostname
  }
}

