resource "azurerm_user_assigned_identity" "this" {
  for_each            = var.managed_identities
  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = merge(var.tags, each.value.tags)
}
