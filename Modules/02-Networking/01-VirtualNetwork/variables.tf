variable "virtual_networks" {
  description = "Map of Virtual Networks to create"
  type        = map(any)
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "Location of resources"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {}
}
