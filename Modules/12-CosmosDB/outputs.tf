output "cosmosdb_account_endpoint" {
  description = "Cosmos DB account endpoint URI"
  value       = azurerm_cosmosdb_account.cosmosdb.endpoint
}

output "cosmosdb_database_id" {
  description = "Cosmos DB SQL database ID"
  value       = azurerm_cosmosdb_sql_database.sqldb.id
}

