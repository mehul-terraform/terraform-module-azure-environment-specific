resource "azurerm_redis_cache" "redis-cache" {
  for_each = var.redis_caches

  name                          = each.value.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  capacity                      = each.value.capacity
  family                        = each.value.family
  sku_name                      = each.value.sku
  non_ssl_port_enabled          = lookup(each.value, "non_ssl_port_enabled", false)
  minimum_tls_version           = lookup(each.value, "minimum_tls_version", "1.2")
  shard_count                   = each.value.sku == "Premium" ? lookup(each.value, "cluster_shard_count", 0) : 0
  private_static_ip_address     = lookup(each.value, "private_static_ip_address", null)
  subnet_id                     = lookup(each.value, "subnet_id", null)
  public_network_access_enabled = lookup(each.value, "public_network_access_enabled", true)
  redis_version                 = lookup(each.value, "redis_version", "6")
  zones                         = lookup(each.value, "zones", [])

  dynamic "redis_configuration" {
    for_each = each.value.redis_configuration != null ? [each.value.redis_configuration] : []

    content {
      aof_backup_enabled              = redis_configuration.value.aof_backup_enabled
      aof_storage_connection_string_0 = redis_configuration.value.aof_storage_connection_string_0
      aof_storage_connection_string_1 = redis_configuration.value.aof_storage_connection_string_1
      maxmemory_reserved              = redis_configuration.value.maxmemory_reserved
      maxmemory_delta                 = redis_configuration.value.maxmemory_delta
      maxmemory_policy                = redis_configuration.value.maxmemory_policy
      maxfragmentationmemory_reserved = redis_configuration.value.maxfragmentationmemory_reserved
      rdb_backup_enabled              = redis_configuration.value.rdb_backup_enabled
      rdb_backup_frequency            = redis_configuration.value.rdb_backup_frequency
      rdb_backup_max_snapshot_count   = redis_configuration.value.rdb_backup_max_snapshot_count
      rdb_storage_connection_string   = redis_configuration.value.rdb_storage_connection_string
    }
  }

  dynamic "patch_schedule" {
    for_each = lookup(each.value, "patch_schedule", {})

    content {
      day_of_week        = patch_schedule.value.day_of_week
      start_hour_utc     = patch_schedule.value.start_hour_utc
      maintenance_window = patch_schedule.value.maintenance_window
    }
  }

  tags = merge(var.tags, lookup(each.value, "tags", {}))

  lifecycle {
    ignore_changes = [redis_configuration[0].rdb_storage_connection_string]
  }
}

resource "azurerm_redis_firewall_rule" "primary" {
  for_each = var.redis_firewall_rules

  name                = each.value.name
  redis_cache_name    = azurerm_redis_cache.redis-cache[each.value.redis_cache_key].name
  resource_group_name = var.resource_group_name
  start_ip            = each.value.start_ip
  end_ip              = each.value.end_ip
}
