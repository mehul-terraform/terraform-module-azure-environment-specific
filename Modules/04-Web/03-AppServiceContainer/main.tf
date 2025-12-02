resource "azurerm_linux_web_app" "app_service_container" {
  name                                           = var.web_app_container_name
  location                                       = var.location
  resource_group_name                            = var.resource_group_name
  service_plan_id                                = var.service_plan_id
  https_only                                     = true
  webdeploy_publish_basic_authentication_enabled = false

  site_config {
    always_on  = true
    ftps_state = "Disabled"
  }

  app_settings = merge(
    var.app_settings,
    var.docker_image_name != null ? { "DOCKER_CUSTOM_IMAGE_NAME" = var.docker_image_name } : {}
  )

  identity { type = "SystemAssigned" }
  tags = merge(var.tags)
}