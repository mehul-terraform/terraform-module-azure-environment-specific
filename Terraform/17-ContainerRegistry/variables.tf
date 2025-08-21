variable "container_registry_name" {
  description = "Name of the Azure Container Registry (lowercase letters and numbers only)"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure location"
  type        = string
}

variable "container_registry_sku" {
  description = "SKU of the container registry (Basic, Standard, Premium)"
  type        = string
}

variable "admin_enabled" {
  description = "Enable admin user for ACR"
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "Enable public network access"
  type        = bool
  default     = true
}

variable "quarantine_policy_enabled" {
  description = "Enable quarantine policy"
  type        = bool
  default     = true
}

variable "zone_redundancy_enabled" {
  description = "Enable zone redundancy"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Base tags"
  type        = map(string)
  default     = {}
}

variable "extra_tags" {
  description = "Extra tags to merge"
  type        = map(string)
  default     = {}
}
