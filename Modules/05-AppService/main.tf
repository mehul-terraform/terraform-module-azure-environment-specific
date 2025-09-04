resource "azurerm_app_service" "app_service" {
  name                = var.app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = var.service_plan_id

  site_config {
    linux_fx_version = var.runtime
  }

  app_settings = var.app_settings
}
