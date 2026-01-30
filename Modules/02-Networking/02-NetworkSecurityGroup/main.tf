resource "azurerm_network_security_group" "nsg" {
  for_each = var.network_security_groups

  name                = each.value.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = merge(var.tags, lookup(each.value, "tags", {}))

  dynamic "security_rule" {
    for_each = lookup(each.value, "rules", [])
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
      description                = lookup(security_rule.value, "description", null)
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg" {
  for_each = {
    for item in flatten([
      for nsg_key, nsg in var.network_security_groups : [
        for subnet_key, subnet_id in lookup(nsg, "subnet_ids", {}) : {
          key       = "${nsg_key}-${subnet_key}"
          nsg_key   = nsg_key
          subnet_id = subnet_id
        }
      ]
    ]) : item.key => item
  }

  subnet_id                 = each.value.subnet_id
  network_security_group_id = azurerm_network_security_group.nsg[each.value.nsg_key].id
}
