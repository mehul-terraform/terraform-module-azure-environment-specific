output "cosmosdb_account_endpoints" {
  description = "Map of Cosmos DB account endpoint URIs"
  value       = { for k, v in azurerm_cosmosdb_account.cosmosdb : k => v.endpoint }
}

output "cosmosdb_account_ids" {
  description = "Map of Cosmos DB account IDs"
  value       = { for k, v in azurerm_cosmosdb_account.cosmosdb : k => v.id }
}

output "cosmosdb_database_ids" {
  description = "Map of Cosmos DB SQL database IDs"
  value       = { for k, v in azurerm_cosmosdb_sql_database.sqldb : k => v.id }
}
