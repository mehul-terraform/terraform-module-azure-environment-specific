resource "azurerm_storage_account" "this" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  tags                     = var.tags
}

resource "azurerm_storage_container" "this" {
  name                  = var.storage_container_name
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = var.container_access_type
}

resource "azurerm_service_plan" "this" {
  name                = var.app_service_plan_name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = var.os_type
  sku_name            = var.sku_name
  tags                = var.tags
}

resource "azurerm_function_app_flex_consumption" "function_app" {
  name                = var.function_app_name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.this.id

  storage_container_type      = "blobContainer"
  storage_container_endpoint  = "${azurerm_storage_account.this.primary_blob_endpoint}${azurerm_storage_container.this.name}"
  storage_authentication_type = "StorageAccountConnectionString"
  storage_access_key          = azurerm_storage_account.this.primary_access_key
  runtime_name                = var.runtime_name
  runtime_version             = var.runtime_version
  maximum_instance_count      = 40
  instance_memory_in_mb       = 4096

  site_config {
  }
  
}