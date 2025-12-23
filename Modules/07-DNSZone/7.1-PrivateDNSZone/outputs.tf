output "private_dns_zone_names" {
  description = "Private DNS Zone names"
  value = {
    for k, z in azurerm_private_dns_zone.private_dns_zone : k => z.name
  }
}

output "private_dns_zone_ids" {
  value = {
    for k, z in azurerm_private_dns_zone.private_dns_zone : k => z.id
  }
}
