output "instance_ids" {
  description = "Map of Redis Cache Instance IDs"
  value       = { for k, v in azurerm_redis_cache.redis-cache : k => v.id }
}

output "hostnames" {
  description = "Map of Redis Cache Hostnames"
  value       = { for k, v in azurerm_redis_cache.redis-cache : k => v.hostname }
}

output "primary_access_keys" {
  description = "Map of Redis Cache Primary Access Keys"
  value       = { for k, v in azurerm_redis_cache.redis-cache : k => v.primary_access_key }
}

output "secondary_access_keys" {
  description = "Map of Redis Cache Secondary Access Keys"
  value       = { for k, v in azurerm_redis_cache.redis-cache : k => v.secondary_access_key }
}

output "primary_connection_strings" {
  description = "Map of Redis Cache Primary Connection Strings"
  value       = { for k, v in azurerm_redis_cache.redis-cache : k => v.primary_connection_string }
}

output "secondary_connection_strings" {
  description = "Map of Redis Cache Secondary Connection Strings"
  value       = { for k, v in azurerm_redis_cache.redis-cache : k => v.secondary_connection_string }
}
