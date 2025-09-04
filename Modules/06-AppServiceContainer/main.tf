resource "azurerm_linux_web_app" "app_service_container" {
  name                = var.linux_web_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id = var.service_plan_id

  site_config {
    always_on = true
  }

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
    docker_registry_url                 = var.docker_registry_url
    Ddocker_registry_username           = var.docker_registry_username
    docker_registry_password            = var.docker_registry_password
  }

  identity {
    type = "SystemAssigned"
  }

  tags = merge(var.tags)
}
