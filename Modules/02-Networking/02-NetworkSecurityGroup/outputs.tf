output "ids" {
  description = "Map of Network Security Group IDs."
  value       = { for k, v in azurerm_network_security_group.nsg : k => v.id }
}

output "names" {
  description = "Map of Network Security Group names."
  value       = { for k, v in azurerm_network_security_group.nsg : k => v.name }
}
