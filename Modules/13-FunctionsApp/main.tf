resource "azurerm_function_app" "functionapp" {
  name                       = var.function_app_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  app_service_plan_id        = azurerm_app_service_plan.asp.id
  storage_account_name       = azurerm_storage_account.sa.name
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key
  version                    = "~4"
  os_type                    = "linux"

  site_config {
    application_stack {
      dotnet_version = var.dotnet_version
    }
  }

  identity {
    type = var.identity_type
  }

  app_settings = merge(
    {
      FUNCTIONS_EXTENSION_VERSION  = "~4"
      WEBSITE_RUN_FROM_PACKAGE     = var.run_from_package
      FUNCTIONS_WORKER_RUNTIME     = var.worker_runtime
      WEBSITE_NODE_DEFAULT_VERSION = var.node_version
    },
    var.app_settings,
  )

  tags = var.tags
}
