variable "network_security_groups" {
  description = "Map of Network Security Groups to create"
  type        = map(any)
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
