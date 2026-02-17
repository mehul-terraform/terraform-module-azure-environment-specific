resource "azurerm_windows_web_app" "app_service" {
  for_each                                       = var.app_service_windows
  name                                           = each.value.app_service_name
  location                                       = var.location
  resource_group_name                            = var.resource_group_name
  service_plan_id                                = var.service_plan_ids[each.value.service_plan_key]
  virtual_network_subnet_id                      = var.subnet_id
  https_only                                     = true
  webdeploy_publish_basic_authentication_enabled = true

  lifecycle {
    ignore_changes = [
      tags,
      app_settings,
      sticky_settings,
      auth_settings,
      site_config,
      site_config[0].cors
    ]
  }

  site_config {
    application_stack {
      dotnet_version = lookup(each.value.runtime, "dotnet_version", null)
      node_version   = lookup(each.value.runtime, "node_version", null)
      php_version    = lookup(each.value.runtime, "php_version", null)
    }
    always_on              = true
    vnet_route_all_enabled = true
    ftps_state             = "Disabled"
  }

  app_settings = each.value.app_settings

  identity { type = "SystemAssigned" }

  tags = each.value.tags
}
