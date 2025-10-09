output "id" {
  description = "The ID of the Storage Account"
  value       = azurerm_storage_account.sa.id
}

output "name" {
  description = "The name of the Storage Account"
  value       = azurerm_storage_account.sa.name
}

output "primary_endpoint" {
  description = "Primary endpoint for the storage account"
  value       = azurerm_storage_account.sa.primary_blob_endpoint
}

output "static_website_url" {
  description = "Static website endpoint of the storage account"
  value       = azurerm_storage_account.sa.primary_web_endpoint
}

output "access_key" {
  value     = azurerm_storage_account.sa.primary_access_key
  sensitive = true
}
