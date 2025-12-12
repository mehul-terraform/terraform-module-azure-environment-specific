output "static_site_id" {
  value = azurerm_static_web_app.static_webapp.id
}

output "static_site_url" {
  value = azurerm_static_web_app.static_webapp.default_host_name
}