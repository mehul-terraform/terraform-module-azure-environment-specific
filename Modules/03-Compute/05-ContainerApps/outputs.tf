output "environment_ids" {
  value = { for k, v in azurerm_container_app_environment.env : k => v.id }
}

output "container_app_ids" {
  value = { for k, v in azurerm_container_app.app : k => v.id }
}

output "container_app_urls" {
  value = { for k, v in azurerm_container_app.app : k => v.latest_revision_fqdn }
}
