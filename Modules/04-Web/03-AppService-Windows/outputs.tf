output "ids" {
  description = "Windows Web App IDs"
  value = {
    for k, v in azurerm_windows_web_app.this :
    k => v.id
  }
}

output "names" {
  description = "Windows Web App Names"
  value = {
    for k, v in azurerm_windows_web_app.this :
    k => v.name
  }
}
