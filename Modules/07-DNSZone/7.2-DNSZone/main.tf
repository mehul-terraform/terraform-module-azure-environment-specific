resource "azurerm_dns_zone" "dnszone" {
  for_each = var.dns_zones

  name                = each.value.name
  resource_group_name = var.resource_group_name
  tags                = merge(var.tags, each.value.tags)
}

resource "azurerm_dns_cname_record" "dns_cname_record" {
  for_each = {
    for record in flatten([
      for zone_key, zone in var.dns_zones : [
        for record_name, record_value in zone.cname_records : {
          zone_key     = zone_key
          record_name  = record_name
          record_value = record_value
        }
      ]
    ]) : "${record.zone_key}-${record.record_name}" => record
  }

  name                = each.value.record_name
  zone_name           = azurerm_dns_zone.dnszone[each.value.zone_key].name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  record              = each.value.record_value
}

resource "azurerm_dns_txt_record" "dns_txt_record" {
  for_each = {
    for record in flatten([
      for zone_key, zone in var.dns_zones : [
        for record_name, record_value in zone.txt_records : {
          zone_key     = zone_key
          record_name  = record_name
          record_value = record_value
        }
      ]
    ]) : "${record.zone_key}-${record.record_name}" => record
  }

  name                = each.value.record_name
  zone_name           = azurerm_dns_zone.dnszone[each.value.zone_key].name
  resource_group_name = var.resource_group_name
  ttl                 = 300

  record {
    value = each.value.record_value
  }
}
