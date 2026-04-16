output "ids" {
  description = "The IDs of the Web PubSub instances."
  value       = { for k, v in azurerm_web_pubsub.this : k => v.id }
}

output "hostnames" {
  description = "The hostnames of the Web PubSub instances."
  value       = { for k, v in azurerm_web_pubsub.this : k => v.hostname }
}

output "primary_connection_strings" {
  description = "The primary connection strings of the Web PubSub instances."
  value       = { for k, v in azurerm_web_pubsub.this : k => v.primary_connection_string }
  sensitive   = true
}

output "secondary_connection_strings" {
  description = "The secondary connection strings of the Web PubSub instances."
  value       = { for k, v in azurerm_web_pubsub.this : k => v.secondary_connection_string }
  sensitive   = true
}
