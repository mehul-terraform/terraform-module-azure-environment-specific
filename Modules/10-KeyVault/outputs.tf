output "ids" {
  description = "The IDs of the Key Vaults"
  value       = { for k, v in azurerm_key_vault.this : k => v.id }
}

output "uris" {
  description = "The URIs of the Key Vaults"
  value       = { for k, v in azurerm_key_vault.this : k => v.vault_uri }
}

output "terraform_kv_secrets_officer_role_assignment_ids" {
  description = "The IDs of the Role Assignments"
  value       = { for k, v in azurerm_role_assignment.this : k => v.id }
}
