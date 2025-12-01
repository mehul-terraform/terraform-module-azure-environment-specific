resource "azurerm_linux_web_app" "app_service" {
  name                = var.web_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = var.service_plan_id
  https_only = true
  webdeploy_publish_basic_authentication_enabled = false

  site_config {
    always_on = true
    ftps_state = "Disabled"

    dynamic "application_stack" {
      for_each = length(var.runtime) > 0 ? [var.runtime] : []

      content {
        dotnet_version = lookup(var.runtime, "dotnet_version", null)
        node_version   = lookup(var.runtime, "node_version", null)
        python_version = lookup(var.runtime, "python_version", null)
      }
    }
  }
  app_settings = var.app_settings

  identity {
    type = "SystemAssigned"
  }

  tags = merge(var.tags)
}
