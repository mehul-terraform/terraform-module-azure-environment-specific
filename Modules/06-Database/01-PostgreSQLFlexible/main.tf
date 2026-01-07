resource "random_password" "admin" {
  for_each = var.postgre_sql

  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2

  # keepers = {
  #   rotation = var.password_rotation_version
  # }
}

resource "azurerm_postgresql_flexible_server" "this" {
  for_each = var.postgre_sql

  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku_name   = each.value.sku_name
  version    = each.value.version
  storage_mb = each.value.storage_mb
  zone       = each.value.zone

  administrator_login    = each.value.admin_login
  administrator_password = random_password.admin[each.key].result

  backup_retention_days        = each.value.backup_retention_days
  geo_redundant_backup_enabled = each.value.geo_redundant_backup_enabled

  delegated_subnet_id = var.delegated_subnet_id
  private_dns_zone_id = var.private_dns_zone_id

  public_network_access_enabled = false

  dynamic "high_availability" {
    for_each = (lookup(each.value, "standby_zone", null) != null && each.value.tier != "Burstable") ? [each.value.standby_zone] : []

    content {
      mode                      = "ZoneRedundant"
      standby_availability_zone = high_availability.value
    }
  }

  dynamic "maintenance_window" {
    for_each = (lookup(each.value, "maintenance_window", null) != null
      ? [each.value.maintenance_window]
      : [])

    content {
      day_of_week  = maintenance_window.value.day_of_week
      start_hour   = maintenance_window.value.start_hour
      start_minute = maintenance_window.value.start_minute
    }
  }

  tags = merge(var.tags, lookup(each.value, "tags", {}))
}

resource "azurerm_postgresql_flexible_server_database" "db" {
  for_each = merge([
    for server_key, server in var.postgre_sql : {
      for db_name, db in server.databases :
      "${server_key}.${db_name}" => {
        server_key = server_key
        name       = db_name
        charset    = db.charset
        collation  = db.collation
      }
    }
  ]...)

  name      = each.value.name
  server_id = azurerm_postgresql_flexible_server.this[each.value.server_key].id
  charset   = each.value.charset
  collation = each.value.collation
}

resource "azurerm_key_vault_secret" "postgres_admin" {
  for_each = var.postgre_sql

  name         = "${each.value.name}-pgpassword"
  value        = random_password.admin[each.key].result
  key_vault_id = var.key_vault_id
}

