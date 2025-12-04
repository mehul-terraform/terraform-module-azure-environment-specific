resource "azurerm_dns_zone" "dnszone" {
  name                = var.dns_zone_name
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_dns_cname_record" "dns_cname_record" {
  for_each = var.cname_records

  name                = each.key
  zone_name           = azurerm_dns_zone.dnszone.name
  resource_group_name = azurerm_dns_zone.dnszone.resource_group_name
  ttl                 = 300
  record              = each.value
}

resource "azurerm_dns_txt_record" "txt_records" {
  for_each = var.txt_records

  name                = each.key
  zone_name           = azurerm_dns_zone.dnszone.name
  resource_group_name = azurerm_dns_zone.dnszone.resource_group_name
  ttl                 = 300

  record {
    value = each.value
  }
}
