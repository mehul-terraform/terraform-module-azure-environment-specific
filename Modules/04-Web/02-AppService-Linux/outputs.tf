output "app_service_ids" {
  value = {
    for k, v in azurerm_linux_web_app.app_service : k => v.id
  }
}

output "default_hostnames" {
  value = {
    for key, app in azurerm_linux_web_app.app_service :
    key => app.default_hostname
  }
}

