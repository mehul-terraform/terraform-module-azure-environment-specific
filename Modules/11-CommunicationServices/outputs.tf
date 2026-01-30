output "communication_service_ids" {
  description = "The IDs of the Azure Communication Services."
  value       = { for k, v in azurerm_communication_service.communication : k => v.id }
}

output "email_service_ids" {
  description = "The IDs of the Email Communication Services."
  value       = { for k, v in azurerm_email_communication_service.email : k => v.id }
}

output "custom_domain_ids" {
  description = "The IDs of the custom email domains."
  value       = { for k, v in azurerm_email_communication_service_domain.custom_domain : k => v.id }
}
