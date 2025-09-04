output "virtual_network_gateway_id" {
  description = "ID of the virtual network gateway"
  value       = azurerm_virtual_network_gateway.vnet_gateway.id
}

output "virtual_network_gateway_ip_configuration" {
  description = "IP configuration of the virtual network gateway"
  value       = azurerm_virtual_network_gateway.vnet_gateway.ip_configuration
}
