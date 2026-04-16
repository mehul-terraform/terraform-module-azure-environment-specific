output "ids" {
  value = { for k, v in azurerm_managed_redis.this : k => v.id }
}

output "hostnames" {
  value = { for k, v in azurerm_managed_redis.this : k => v.hostname }
}

output "primary_access_keys" {
  value     = { for k, v in azurerm_managed_redis.this : k => v.default_database[0].primary_access_key }
  sensitive = true
}
