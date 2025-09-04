variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "virtual_network_gateway_name" {
  description = "Name of the virtual network gateway"
  type        = string
}

variable "virtual_network_id" {
  description = "ID of the virtual network"
  type        = string
}

variable "public_ip_address_id" {
  description = "ID of the public IP address resource"
  type        = string
}

variable "allocation_method" {
  description = "ID of the public IP address resource"
  type        = string
}

variable "gateway_type" {
  description = "The type of this virtual network gateway. Possible values are 'Vpn' and 'ExpressRoute'"
  type        = string
  default     = "Vpn"
}

variable "vpn_type" {
  description = "The type of VPN. Possible values are 'PolicyBased' and 'RouteBased'"
  type        = string
  default     = "RouteBased"
}

variable "active_active" {
  description = "Whether active-active mode is enabled"
  type        = bool
  default     = false
}

variable "virtual_network_gateway_sku" {
  description = "The SKU of the virtual network gateway. Possible values: 'Basic', 'VpnGw1', 'VpnGw2', etc."
  type        = string
  default     = "VpnGw1"
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