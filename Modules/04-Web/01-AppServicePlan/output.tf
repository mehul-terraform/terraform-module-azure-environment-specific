output "ids" {
  description = "Map of App Service Plan IDs"
  value = {
    for k, v in azurerm_service_plan.asp :
    k => v.id
  }
}

output "names" {
  description = "Map of App Service Plan Names"
  value = {
    for k, v in azurerm_service_plan.asp :
    k => v.name
  }
}
