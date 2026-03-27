variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "managed_identities" {
  description = "Map of managed identities to create"
  type = map(object({
    name = string
    tags = optional(map(string), {})
  }))
}

variable "tags" {
  description = "Common tags for all identities"
  type        = map(string)
  default     = {}
}
