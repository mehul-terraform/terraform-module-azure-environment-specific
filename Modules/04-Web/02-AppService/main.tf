resource "azurerm_linux_web_app" "app_service" {
  for_each = var.app_services

  name                = each.value.web_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = var.service_plan_id

  app_settings = each.value.app_settings
  tags         = merge(var.tags, each.value.tags)

  site_config {
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
