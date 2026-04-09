output "ids" {
  value = { for k, v in azurerm_redis_cache.redis : k => v.id }
}

output "hostnames" {
  value = { for k, v in azurerm_redis_cache.redis : k => v.hostname }
}

output "ssl_ports" {
  value = { for k, v in azurerm_redis_cache.redis : k => v.ssl_port }
}

output "primary_access_keys" {
  value     = { for k, v in azurerm_redis_cache.redis : k => v.primary_access_key }
  sensitive = true
}
