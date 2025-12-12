resource "azurerm_linux_web_app" "app_service_container" {
  for_each                                       = var.app_service_container
  name                                           = each.value.app_service_container_name
  location                                       = var.location
  resource_group_name                            = var.resource_group_name
  service_plan_id                                = var.service_plan_id
  https_only                                     = true
  webdeploy_publish_basic_authentication_enabled = true

  lifecycle {
    ignore_changes = [
      tags,
      app_settings,
      site_config,
    ]
  }

  site_config {
    application_stack {
      docker_image_name = each.value.docker_image_name
    }
    always_on              = true
    vnet_route_all_enabled = true
    ftps_state             = "Disabled"
  }

  app_settings = each.value.app_settings

  identity { type = "SystemAssigned" }

  tags = each.value.tags
}
