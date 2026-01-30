output "ids" {
  description = "Map of Virtual Network IDs"
  value       = { for k, v in azurerm_virtual_network.vnet : k => v.id }
}

output "names" {
  description = "Map of Virtual Network names"
  value       = { for k, v in azurerm_virtual_network.vnet : k => v.name }
}

output "subnets" {
  description = "Map of all subnet IDs"
  value = {
    for k, v in azurerm_subnet.subnets : k => {
      id   = v.id
      name = v.name
    }
  }
}

# Helper outputs for common subnet lookups
output "subnet_ids" {
  description = "Flat map of subnet IDs by their key (vnet_key-subnet_name)"
  value       = { for k, v in azurerm_subnet.subnets : k => v.id }
}
