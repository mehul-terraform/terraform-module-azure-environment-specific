output "virtual_network_gateway_ids" {
  description = "Map of Virtual Network Gateway IDs"
  value       = { for k, v in azurerm_virtual_network_gateway.vnet_gateway : k => v.id }
}

output "virtual_network_gateway_ip_configurations" {
  description = "Map of IP IP configurations of the virtual network gateways"
  value       = { for k, v in azurerm_virtual_network_gateway.vnet_gateway : k => v.ip_configuration }
}
