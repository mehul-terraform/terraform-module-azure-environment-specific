resource "azurerm_private_endpoint" "this" {
  for_each = var.private_endpoints

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  subnet_id           = each.value.subnet_id

  private_service_connection {
    name                           = "${each.value.name}-psc"
    private_connection_resource_id = each.value.resource_id
    subresource_names              = each.value.subresource_names
    is_manual_connection           = each.value.is_manual_connection
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = each.value.private_dns_zone_ids
  }

  tags = each.value.tags
}