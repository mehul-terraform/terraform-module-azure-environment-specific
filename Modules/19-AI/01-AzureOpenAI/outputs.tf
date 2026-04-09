output "account_ids" {
  value = { for k, v in azurerm_cognitive_account.openai : k => v.id }
}

output "endpoints" {
  value = { for k, v in azurerm_cognitive_account.openai : k => v.endpoint }
}

output "primary_keys" {
  value     = { for k, v in azurerm_cognitive_account.openai : k => v.primary_access_key }
  sensitive = true
}

output "deployment_ids" {
  value = { for k, v in azurerm_cognitive_deployment.deployment : k => v.id }
}
