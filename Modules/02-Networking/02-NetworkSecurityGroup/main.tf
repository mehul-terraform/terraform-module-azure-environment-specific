resource "azurerm_network_security_group" "nsg" {
  name                = var.network_security_group_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = merge(var.tags)

  dynamic "security_rule" {
    for_each = var.network_security_group_rules
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

resource "azurerm_subnet_network_security_group_association" "vm_subnet_nsg" {
  subnet_id                 = var.vm_subnet_id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_subnet_network_security_group_association" "db_subnet_nsg" {
  subnet_id                 = var.db_subnet_id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_subnet_network_security_group_association" "webapp_subnet_nsg" {
  subnet_id                 = var.webapp_subnet_id
  network_security_group_id = azurerm_network_security_group.nsg.id
}