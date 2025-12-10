variable "network_security_group_name" {
  description = "The name of the Network Security Group."
  type        = string
}

variable "location" {
  description = "The Azure region where the NSG should be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the NSG will be created."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "network_security_group_rules" {
  description = "List of security rules to apply to the NSG."
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = []
}

variable "vm_subnet_id" {
  description = "The Azure region where the NSG should be created."
  type        = string
}

variable "db_subnet_id" {
  description = "The Azure region where the NSG should be created."
  type        = string
}

variable "webapp_subnet_id" {
  description = "The Azure region where the NSG should be created."
  type        = string
}

