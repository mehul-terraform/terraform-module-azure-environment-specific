output "frontdoor_frontend_validation_token" {
  value       = azurerm_cdn_frontdoor_custom_domain.custome_domain_frontend.validation_token
  description = "Validation token for backend custom domain (string)"
}

output "frontdoor_backend_validation_token" {
  value       = azurerm_cdn_frontdoor_custom_domain.custome_domain_backend.validation_token
  description = "Validation token for backend custom domain (string)"
}

output "frontend_endpoint" {
  value       = azurerm_cdn_frontdoor_endpoint.endpoint_frontend.host_name
  description = "Validation token for backend custom domain (string)"
}

output "backend_endpoint" {
  value       = azurerm_cdn_frontdoor_endpoint.endpoint_backend.host_name
  description = "Validation token for backend custom domain (string)"
}

