# Storage Account for each Function App
resource "azurerm_storage_account" "this" {
  for_each = var.function_apps

  name                     = each.value.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = merge(var.tags, lookup(each.value, "tags", {}))
}

# Service Plan for each Function App
resource "azurerm_service_plan" "this" {
  for_each = var.function_apps

  name                = each.value.service_plan_name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = lookup(each.value, "sku_name", "Y1")
  tags                = merge(var.tags, lookup(each.value, "tags", {}))
}

# Linux Function App
resource "azurerm_linux_function_app" "this" {
  for_each = var.function_apps

  name                = each.value.function_app_name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.this[each.key].id

  storage_account_name       = azurerm_storage_account.this[each.key].name
  storage_account_access_key = azurerm_storage_account.this[each.key].primary_access_key

  https_only = lookup(each.value, "https_only", true)

  site_config {
    always_on  = lookup(each.value, "always_on", false)
    ftps_state = lookup(each.value, "ftps_state", "Disabled")

    application_stack {
      dotnet_version          = each.value.runtime_stack == "dotnet" ? each.value.runtime_version : null
      node_version            = each.value.runtime_stack == "node" ? each.value.runtime_version : null
      python_version          = each.value.runtime_stack == "python" ? each.value.runtime_version : null
      java_version            = each.value.runtime_stack == "java" ? each.value.runtime_version : null
      powershell_core_version = each.value.runtime_stack == "powershell" ? each.value.runtime_version : null
    }
  }

  app_settings = lookup(each.value, "app_settings", {})
  tags         = merge(var.tags, lookup(each.value, "tags", {}))
}
