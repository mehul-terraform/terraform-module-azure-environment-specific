output "ids" {
  description = "Windows Web App IDs"
  value = {
    for k, v in azurerm_windows_web_app.app_service :
    k => v.id
  }
}

output "names" {
  description = "Windows Web App names"
  value = {
    for k, v in azurerm_windows_web_app.app_service :
    k => v.name
  }
}
