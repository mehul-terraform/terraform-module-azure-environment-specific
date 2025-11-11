resource "azurerm_user_assigned_identity" "app" {
  name                = "${var.key_vault_name}-uami"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_key_vault" "keyvault" {
  name                       = var.key_vault_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = var.tenant_id
  sku_name                   = var.sku_name
  soft_delete_retention_days = var.soft_delete_retention_days
  purge_protection_enabled   = var.purge_protection_enabled

  rbac_authorization_enabled = true    
  public_network_access_enabled = true

  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"    
  }

  tags = merge(var.tags)
} 

resource "azurerm_role_assignment" "kv_secrets_reader" {
  scope                = azurerm_key_vault.keyvault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.app.principal_id
}

data "azurerm_client_config" "current" {}

resource "azurerm_role_assignment" "terraform_access" {
  scope                = azurerm_key_vault.keyvault.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_key_vault_secret" "example_secret" {
  name         = "db-password"
  value        = "P@ssw0rd123"
  key_vault_id = azurerm_key_vault.keyvault.id
}