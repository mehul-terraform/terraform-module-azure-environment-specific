variable "location" {
  description = "Azure Region"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to be applied to resources (inclusive)"
  type        = map(string)
  default     = {}
}

variable "redis_caches" {
  description = "Map of Redis Caches to create"
  type = map(object({
    name                          = string
    capacity                      = number
    family                        = string
    sku                           = string
    non_ssl_port_enabled          = optional(bool, false)
    minimum_tls_version           = optional(string, "1.2")
    cluster_shard_count           = optional(number, 0)
    private_static_ip_address     = optional(string)
    subnet_id                     = optional(string)
    public_network_access_enabled = optional(bool, true)
    redis_version                 = optional(string, "6")
    zones                         = optional(list(string), [])

    redis_configuration = optional(object({
      aof_backup_enabled              = optional(bool)
      aof_storage_connection_string_0 = optional(string)
      aof_storage_connection_string_1 = optional(string)

      maxmemory_reserved              = optional(number)
      maxmemory_delta                 = optional(number)
      maxmemory_policy                = optional(string)
      maxfragmentationmemory_reserved = optional(number)
      rdb_backup_enabled              = optional(bool)
      rdb_backup_frequency            = optional(number)
      rdb_backup_max_snapshot_count   = optional(number)
      rdb_storage_connection_string   = optional(string)
    }), {})

    patch_schedule = optional(map(object({
      day_of_week        = string
      start_hour_utc     = optional(number)
      maintenance_window = optional(string)
    })), {})

    tags = optional(map(string), {})
  }))
  default = {}
}

variable "redis_firewall_rules" {
  description = "Map of firewall rules for all Redis caches. Key should be composite or unique."
  type = map(object({
    redis_cache_key = string # Key of the redis cache in var.redis_caches
    name            = string
    start_ip        = string
    end_ip          = string
  }))
  default = {}
}
