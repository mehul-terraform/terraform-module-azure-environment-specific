resource "azurerm_managed_redis" "this" {
  for_each = var.managed_redis_instances

  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name
  
  # Azure Managed Redis (AMR) uses unified SKU names (e.g., Balanced_B0)
  sku_name            = lookup(each.value, "sku_name", "Balanced_B0")

  default_database {
    access_keys_authentication_enabled = lookup(each.value, "access_keys_authentication_enabled", true)
  }

  tags = merge(var.tags, lookup(each.value, "tags", {}))
}
