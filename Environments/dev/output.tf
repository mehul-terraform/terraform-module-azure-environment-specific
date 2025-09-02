
output "cosmosdb_account_endpoint" {
  description = "Cosmos DB account endpoint URI"
  value       = module.cosmosdb.cosmosdb_account_endpoint
}

output "cosmosdb_database_id" {
  description = "Cosmos DB SQL database ID"
  value       = module.cosmosdb.cosmosdb_database_id
}
