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

output "terraform_kv_secrets_officer_role_assignment_id" {
  description = "Role Assignment ID for Terraform identity as Key Vault Secrets Officer"
  value       = azurerm_role_assignment.kv_secrets_officer_user
}

