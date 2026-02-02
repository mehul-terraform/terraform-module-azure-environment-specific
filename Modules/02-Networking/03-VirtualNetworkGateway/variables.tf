variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}


variable "virtual_network_gateways" {
  description = "Map of Virtual Network Gateways to create"
  type = map(object({
    name                             = string
    public_ip_name                   = string
    public_ip_allocation_method      = optional(string, "Static")
    gateway_type                     = optional(string, "Vpn")
    vpn_type                         = optional(string, "RouteBased")
    active_active                    = optional(bool, false)
    sku                              = optional(string, "VpnGw1")
    default_local_network_gateway_id = optional(string)
    enable_bgp                       = optional(bool, false)
    generation                       = optional(string, "Generation1")
    private_ip_address_allocation    = optional(string, "Dynamic")
    bgp_settings = optional(object({
      asn         = number
      peer_weight = number
      peering_addresses = list(object({
        ip_configuration_name = optional(string)
        apipa_addresses       = list(string)
      }))
    }))
    vpn_client_configuration = optional(object({
      address_space = list(string)
      root_certificate = list(object({
        name             = string
        public_cert_data = string
      }))
      revoked_certificate = list(object({
        name       = string
        thumbprint = string
      }))
      radius_server_address = optional(string)
      radius_server_secret  = optional(string)
      vpn_client_protocols  = optional(list(string))
      vpn_auth_types        = optional(list(string))
    }))
    tags = optional(map(string), {})
  }))
}

variable "tags" {
  description = "Tags for the resource"
  type        = map(string)
  default     = {}
}

variable "subnet_id" {
  description = "The subnet ID to associate with the network interface"
  type        = string
}
