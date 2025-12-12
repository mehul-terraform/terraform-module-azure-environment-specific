output "id" {
  description = "The ID of the private endpoint."
  value       = azurerm_private_endpoint.private_endpoint.id
}

output "name" {
  description = "The name of the private endpoint."
  value       = azurerm_private_endpoint.private_endpoint.name
}

/*
output "dns_zone_group_name" {
  value = azurerm_private_endpoint.private_endpoint.private_dns_zone_group[0].name
}

output "dns_zone_ids" {
  value = azurerm_private_endpoint.private_endpoint.private_dns_zone_group[0].private_dns_zone_ids
}
*/