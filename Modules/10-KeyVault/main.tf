resource "azurerm_key_vault" "this" {
  for_each = var.key_vaults

  name                        = each.value.name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = lookup(each.value, "enabled_for_disk_encryption", true)
  tenant_id                   = var.tenant_id
  soft_delete_retention_days  = lookup(each.value, "soft_delete_retention_days", 7)
  purge_protection_enabled    = lookup(each.value, "purge_protection_enabled", false)

  sku_name = lookup(each.value, "sku_name", "standard")

  enabled_for_deployment          = lookup(each.value, "enabled_for_deployment", false)
  enabled_for_template_deployment = lookup(each.value, "enabled_for_template_deployment", false)
  rbac_authorization_enabled      = lookup(each.value, "rbac_authorization_enabled", lookup(each.value, "enable_rbac_authorization", false))
  public_network_access_enabled   = lookup(each.value, "public_network_access_enabled", true)

  dynamic "network_acls" {
    for_each = lookup(each.value, "network_acls", null) != null ? [each.value.network_acls] : []
    content {
      bypass                     = lookup(network_acls.value, "bypass", "AzureServices")
      default_action             = lookup(network_acls.value, "default_action", "Allow")
      ip_rules                   = lookup(network_acls.value, "ip_rules", [])
      virtual_network_subnet_ids = lookup(network_acls.value, "virtual_network_subnet_ids", [])
    }
  }

  tags = merge(var.tags, lookup(each.value, "tags", {}))
}

resource "azurerm_role_assignment" "this" {
  for_each             = var.key_vaults
  scope                = azurerm_key_vault.this[each.key].id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = var.current_user_object_id
}
