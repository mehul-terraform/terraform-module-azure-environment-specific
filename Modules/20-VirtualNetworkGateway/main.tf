resource "azurerm_container_registry" "acr" {
  name                          = var.container_registry_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  sku                           = var.container_registry_sku
  admin_enabled                 = var.admin_enabled
  public_network_access_enabled = var.public_network_access_enabled
  quarantine_policy_enabled     = var.quarantine_policy_enabled
  zone_redundancy_enabled       = var.zone_redundancy_enabled
  tags                          = merge(var.tags)
}

