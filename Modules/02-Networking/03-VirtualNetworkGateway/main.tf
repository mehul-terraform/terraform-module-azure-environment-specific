resource "azurerm_public_ip" "public_ip" {
  for_each = var.virtual_network_gateways

  name                = each.value.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = each.value.public_ip_allocation_method
  tags                = merge(var.tags, each.value.tags)
}

resource "azurerm_virtual_network_gateway" "vnet_gateway" {
  for_each = var.virtual_network_gateways

  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name

  type     = each.value.gateway_type
  vpn_type = each.value.vpn_type

  active_active = each.value.active_active
  sku           = each.value.sku
  generation    = each.value.generation

  default_local_network_gateway_id = each.value.default_local_network_gateway_id
  enable_bgp                       = each.value.enable_bgp
  private_ip_address_enabled       = each.value.private_ip_address_allocation == "Static" ? true : false

  ip_configuration {
    name                          = "${each.value.name}-ipconfig"
    public_ip_address_id          = azurerm_public_ip.public_ip[each.key].id
    private_ip_address_allocation = each.value.private_ip_address_allocation
    subnet_id                     = var.subnet_id
  }

  dynamic "bgp_settings" {
    for_each = each.value.bgp_settings != null ? [each.value.bgp_settings] : []
    content {
      asn         = bgp_settings.value.asn
      peer_weight = bgp_settings.value.peer_weight
      dynamic "peering_addresses" {
        for_each = bgp_settings.value.peering_addresses
        content {
          ip_configuration_name = peering_addresses.value.ip_configuration_name
          apipa_addresses       = peering_addresses.value.apipa_addresses
        }
      }
    }
  }

  dynamic "vpn_client_configuration" {
    for_each = each.value.vpn_client_configuration != null ? [each.value.vpn_client_configuration] : []
    content {
      address_space = vpn_client_configuration.value.address_space

      dynamic "root_certificate" {
        for_each = vpn_client_configuration.value.root_certificate
        content {
          name             = root_certificate.value.name
          public_cert_data = root_certificate.value.public_cert_data
        }
      }

      dynamic "revoked_certificate" {
        for_each = vpn_client_configuration.value.revoked_certificate
        content {
          name       = revoked_certificate.value.name
          thumbprint = revoked_certificate.value.thumbprint
        }
      }

      radius_server_address = vpn_client_configuration.value.radius_server_address
      radius_server_secret  = vpn_client_configuration.value.radius_server_secret
      vpn_client_protocols  = vpn_client_configuration.value.vpn_client_protocols
      vpn_auth_types        = vpn_client_configuration.value.vpn_auth_types
    }
  }

  tags = merge(var.tags, each.value.tags)
}
