resource "azurerm_linux_web_app" "app_service_container" {
  name                = var.web_app_container_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = var.service_plan_id
 
  site_config {
    always_on = true
  }

  app_settings = var.app_settings

  identity {
    type = "SystemAssigned"
  }

  tags = merge(var.tags)
  
}
