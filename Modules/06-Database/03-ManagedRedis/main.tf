resource "azurerm_redis_cache" "redis" {
  for_each = var.managed_redis_instances

  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name
  capacity            = lookup(each.value, "capacity", 1)
  family              = lookup(each.value, "family", "C")
  sku_name            = lookup(each.value, "sku_name", "Basic") # Supporting AMR SKUs

  non_ssl_port_enabled          = lookup(each.value, "non_ssl_port_enabled", false)
  minimum_tls_version           = lookup(each.value, "minimum_tls_version", "1.2")
  public_network_access_enabled = lookup(each.value, "public_network_access_enabled", true)
  redis_version                 = lookup(each.value, "redis_version", "6")

  dynamic "redis_configuration" {
    for_each = lookup(each.value, "redis_configuration", null) != null ? [each.value.redis_configuration] : []
    content {
      maxmemory_reserved = lookup(redis_configuration.value, "maxmemory_reserved", null)
      maxmemory_delta    = lookup(redis_configuration.value, "maxmemory_delta", null)
      maxmemory_policy   = lookup(redis_configuration.value, "maxmemory_policy", null)
    }
  }

  tags = merge(var.tags, lookup(each.value, "tags", {}))
}
