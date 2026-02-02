output "frontdoor_frontend_validation_token" {
  value       = { for k, v in azurerm_cdn_frontdoor_custom_domain.custome_domain_frontend : k => v.validation_token }
  description = "Validation token for frontend custom domain (map)"
}

output "frontdoor_backend_validation_token" {
  value       = { for k, v in azurerm_cdn_frontdoor_custom_domain.custome_domain_backend : k => v.validation_token }
  description = "Validation token for backend custom domain (map)"
}

output "frontend_endpoint" {
  value       = { for k, v in azurerm_cdn_frontdoor_endpoint.endpoint_frontend : k => v.host_name }
  description = "Frontend endpoint hostname (map)"
}

output "backend_endpoint" {
  value       = { for k, v in azurerm_cdn_frontdoor_endpoint.endpoint_backend : k => v.host_name }
  description = "Backend endpoint hostname (map)"
}

