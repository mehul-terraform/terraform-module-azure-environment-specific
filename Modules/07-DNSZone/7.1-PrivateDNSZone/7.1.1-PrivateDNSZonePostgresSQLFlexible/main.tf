resource "azurerm_private_dns_zone" "postgressql_flexible" {
  name                = var.private_dns_zone_name
  resource_group_name = var.resource_group_name
  tags                = merge(var.tags)
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgressql_flexible" {
  name                  = var.virtual_network_link_name
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.postgressql_flexible.name
  virtual_network_id    = var.virtual_network_id
  registration_enabled  = false
}