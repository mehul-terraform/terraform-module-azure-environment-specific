variable "private_dns_zone_name" {
  description = "Private DNS zone name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group for DNS zone"
  type        = string
}

variable "virtual_network_link_name" {
  description = "Name of the virtual network link"
  type        = string
}

variable "virtual_network_id" {
  description = "ID of the virtual network"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "tags" {
  description = "Tags for the Private Endpoint"
  type        = map(string)
  default     = {}
}