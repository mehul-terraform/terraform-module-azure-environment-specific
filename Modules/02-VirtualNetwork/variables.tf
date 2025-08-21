variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "Location of resources"
}

variable "virtual_network_name" {
  type        = string
  description = "Name of the virtual network"
}

variable "address_space" {
  type        = list(string)
  description = "VNet address space"
}

variable "subnets" {
  type = list(object({
    name           = string
    address_prefix = string
  }))
  description = "List of subnets with name and address prefix"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {}
}