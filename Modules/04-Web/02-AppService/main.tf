resource "azurerm_linux_web_app" "app_service" {
  for_each = var.app_service

  name                                           = each.value.app_service_name
  location                                       = var.location
  resource_group_name                            = var.resource_group_name
  service_plan_id                                = var.service_plan_id
  webdeploy_publish_basic_authentication_enabled = true
  virtual_network_subnet_id = var.subnet_id

  app_settings = each.value.app_settings
  tags         = merge(var.tags, each.value.tags)

  identity { type = "SystemAssigned" }  

  lifecycle {
    ignore_changes = [
      tags,
      app_settings
    ]
  }

  site_config {
    vnet_route_all_enabled = true
    dynamic "application_stack" {
      for_each = length(each.value.runtime) > 0 ? [each.value.runtime] : []

      content {
        dotnet_version = lookup(each.value.runtime, "dotnet_version", null)
        node_version   = lookup(each.value.runtime, "node_version", null)
        python_version = lookup(each.value.runtime, "python_version", null)
      }
    }
  }
}

