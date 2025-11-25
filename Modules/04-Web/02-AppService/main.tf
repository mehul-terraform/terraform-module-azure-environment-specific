resource "azurerm_linux_web_app" "app_service" {
  name                = var.web_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = var.service_plan_id

  site_config {
    application_stack {
      node_version = var.runtime # e.g., "18-lts"
    }
  }
  app_settings = var.app_settings
}
