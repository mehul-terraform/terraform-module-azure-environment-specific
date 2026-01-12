output "id" {
  value = azurerm_key_vault.keyvault.id
}

output "uri" {
  value = azurerm_key_vault.keyvault.vault_uri
}

output "key_vault_secret_ids" {
  description = "IDs of Key Vault secrets"
  value = {
    for k, v in azurerm_key_vault_secret.secrets :
    k => v.id
  }
}
