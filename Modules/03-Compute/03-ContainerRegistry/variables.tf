variable "container_registries" {
  description = "Map of Container Registries to create"
  type        = map(any)
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure location"
  type        = string
}

variable "tags" {
  description = "Base tags"
  type        = map(string)
  default     = {}
}
