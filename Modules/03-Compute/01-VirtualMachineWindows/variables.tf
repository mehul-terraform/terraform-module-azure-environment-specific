variable "virtual_machines" {
  description = "Map of Windows Virtual Machines to create"
  type        = map(any)
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region to deploy resources"
  type        = string
}

variable "subnet_id" {
  description = "The subnet ID to associate with the network interface"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
  default     = {}
}

variable "key_vault_id" {
  description = "Key Vault ID to store VM admin passwords"
  type        = string
}
