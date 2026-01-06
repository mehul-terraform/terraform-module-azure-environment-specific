resource "azurerm_windows_web_app" "app_service" {
  for_each = var.app_service_windows

  name                = each.value.app_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = var.service_plan_id

  virtual_network_subnet_id = var.subnet_id
  https_only                = true

  webdeploy_publish_basic_authentication_enabled = false

  app_settings = each.value.app_settings
  tags         = merge(var.tags, each.value.tags)

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      tags,
      app_settings
    ]
  }

  site_config {
    always_on = true

    vnet_route_all_enabled = true
 
    dotnet_version = lookup(each.value.runtime, "dotnet_version", null)
    node_version   = lookup(each.value.runtime, "node_version", null)
    php_version    = lookup(each.value.runtime, "php_version", null)
  }
}