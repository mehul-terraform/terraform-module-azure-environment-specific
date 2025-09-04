resource "azurerm_linux_function_app" "functionapp" {
  name                       = var.function_app_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  service_plan_id            = var.app_service_plan_name
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key

  identity {
    type = var.identity_type
  }

  app_settings = merge(
    {
      FUNCTIONS_EXTENSION_VERSION  = "~4"
      WEBSITE_RUN_FROM_PACKAGE     = var.run_from_package
      FUNCTIONS_WORKER_RUNTIME     = var.worker_runtime
      WEBSITE_NODE_DEFAULT_VERSION = var.function_app_node_version
    },
    var.app_settings,
  )

  site_config {
    application_stack {
      # Use this based on your runtime. For example:
      node_version = "22"
      # dotnet_version = "6"
      # python_version = "3.11"
    }
  }

  tags = var.tags
}
