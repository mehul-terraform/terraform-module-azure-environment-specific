output "id" {
  description = "ID of the Private DNS Zone"
  value       = azurerm_private_dns_zone.postgressql_flexible.id
}
