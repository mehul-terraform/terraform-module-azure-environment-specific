resource "azurerm_container_registry" "acr" {
  for_each                      = var.container_registries
  name                          = each.value.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  sku                           = lookup(each.value, "sku", "Basic")
  admin_enabled                 = lookup(each.value, "admin_enabled", true)
  public_network_access_enabled = lookup(each.value, "public_network_access_enabled", true)
  quarantine_policy_enabled     = lookup(each.value, "quarantine_policy_enabled", false)
  zone_redundancy_enabled       = lookup(each.value, "zone_redundancy_enabled", false)
  tags                          = merge(var.tags, lookup(each.value, "tags", {}))
}

