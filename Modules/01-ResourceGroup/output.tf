output "ids" {
  description = "Map of Resource Group IDs"
  value       = { for k, v in azurerm_resource_group.rg : k => v.id }
}

output "locations" {
  description = "Map of Resource Group locations"
  value       = { for k, v in azurerm_resource_group.rg : k => v.location }
}

output "names" {
  description = "Map of Resource Group names"
  value       = { for k, v in azurerm_resource_group.rg : k => v.name }
}

#output "rg" {
#  description = "Resource group resource"
#  value       = azurerm_resource_group.rg
#}
