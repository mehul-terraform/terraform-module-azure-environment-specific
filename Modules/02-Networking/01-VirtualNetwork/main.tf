resource "azurerm_virtual_network" "vnet" {
  for_each = var.virtual_networks

  name                = each.value.name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = each.value.address_space
  tags                = merge(var.tags, lookup(each.value, "tags", {}))
}

locals {
  # Flatten subnets across all VNets for for_each
  subnets = flatten([
    for vnet_key, vnet in var.virtual_networks : [
      for subnet in lookup(vnet, "subnets", []) : {
        key            = "${vnet_key}-${subnet.name}"
        vnet_key       = vnet_key
        subnet_name    = subnet.name
        address_prefix = subnet.address_prefix
        delegation     = lookup(subnet, "delegation", null)
      }
    ]
  ])
}

resource "azurerm_subnet" "subnets" {
  for_each = { for s in local.subnets : s.key => s }

  name                 = each.value.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet[each.value.vnet_key].name
  address_prefixes     = [each.value.address_prefix]

  dynamic "delegation" {
    for_each = each.value.delegation == null ? [] : [each.value.delegation]
    content {
      name = delegation.value.name
      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = delegation.value.service_delegation.actions
      }
    }
  }
}
