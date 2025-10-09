output "id" {
  description = "The ID of the private endpoint."
  value       = azurerm_private_endpoint.storage_account_private_endpoint.id
}

output "name" {
  description = "The name of the private endpoint."
  value       = azurerm_private_endpoint.storage_account_private_endpoint.name
}