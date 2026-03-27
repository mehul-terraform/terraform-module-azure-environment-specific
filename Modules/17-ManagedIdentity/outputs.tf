output "ids" {
  description = "Map of managed identity IDs"
  value       = { for k, v in azurerm_user_assigned_identity.this : k => v.id }
}

output "principal_ids" {
  description = "Map of managed identity principal IDs"
  value       = { for k, v in azurerm_user_assigned_identity.this : k => v.principal_id }
}

output "client_ids" {
  description = "Map of managed identity client IDs"
  value       = { for k, v in azurerm_user_assigned_identity.this : k => v.client_id }
}
