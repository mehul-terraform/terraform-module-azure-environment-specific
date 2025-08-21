output "communication_service_id" {
  description = "The ID of the Azure Communication Service."
  value       = azurerm_communication_service.communication.id
}

output "email_service_id" {
  description = "The ID of the Email Communication Service."
  value       = azurerm_email_communication_service.email.id
}

output "custom_domain_id" {
 description = "The ID of the custom email domain."
  value       = azurerm_email_communication_service_domain.custom_domain.id
}
