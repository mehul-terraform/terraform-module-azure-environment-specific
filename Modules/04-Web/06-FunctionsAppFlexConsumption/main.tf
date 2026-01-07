resource "azurerm_storage_account" "this" {
  for_each = var.function_apps

  name                     = each.value.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags
}

resource "azurerm_storage_container" "this" {
  for_each = var.function_apps

  name                  = each.value.storage_container_name
  storage_account_id    = azurerm_storage_account.this[each.key].id
  container_access_type = "private"
}

resource "azurerm_service_plan" "this" {
  for_each = var.function_apps

  name                = each.value.service_plan_name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = each.value.os_type
  sku_name            = "FC1"
  tags                = var.tags
}

resource "azurerm_function_app_flex_consumption" "this" {
  for_each = var.function_apps

  name                = each.value.function_app_name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.this[each.key].id

  virtual_network_subnet_id = lookup(each.value, "subnet_id", null)

  storage_container_type      = "blobContainer"
  storage_container_endpoint  = "${azurerm_storage_account.this[each.key].primary_blob_endpoint}${azurerm_storage_container.this[each.key].name}"
  storage_authentication_type = "StorageAccountConnectionString"
  storage_access_key          = azurerm_storage_account.this[each.key].primary_access_key

  runtime_name           = each.value.runtime_name
  runtime_version        = each.value.runtime_version
  maximum_instance_count = lookup(each.value, "maximum_instance_count", 40)
  instance_memory_in_mb  = lookup(each.value, "instance_memory_in_mb", 4096)

  site_config {}
}
