resource "azurerm_public_ip" "public_ip" {
  name                = var.public_ip_address_id
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.allocation_method
  tags                = merge(var.tags)
}

resource "azurerm_virtual_network_gateway" "vnet_gateway" {
  name                = var.virtual_network_gateway_name
  location            = var.location
  resource_group_name = var.resource_group_name

  type     = var.gateway_type
  vpn_type = var.vpn_type

  active_active = var.active_active
  sku           = var.virtual_network_gateway_sku

  ip_configuration {
    name                 = "${var.virtual_network_gateway_name}-ipconfig"
    public_ip_address_id = azurerm_public_ip.public_ip.id
    subnet_id            = var.subnet_id
  }

 tags = merge(var.tags)
}
