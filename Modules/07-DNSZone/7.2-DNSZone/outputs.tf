output "dns_zone_id" {
  value = { for k, v in azurerm_dns_zone.dnszone : k => v.id }
}
