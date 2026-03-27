output "static_site_ids" {
  value = { for k, v in azurerm_static_web_app.static_webapp : k => v.id }
}

output "static_site_urls" {
  value = { for k, v in azurerm_static_web_app.static_webapp : k => v.default_host_name }
}
