resource "azurerm_cosmosdb_account" "cosmosdb" {
  for_each = var.cosmos_dbs

  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"
  tags                = merge(var.tags, each.value.tags)

  consistency_policy {
    consistency_level       = each.value.consistency_level
    max_interval_in_seconds = each.value.max_interval_in_seconds
    max_staleness_prefix    = each.value.max_staleness_prefix
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }

  capabilities {
    name = "EnableServerless"
  }
}

resource "azurerm_cosmosdb_sql_database" "sqldb" {
  for_each = var.cosmos_dbs

  name                = each.value.database_name
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.cosmosdb[each.key].name
}
