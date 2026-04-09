variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

variable "managed_redis_instances" {
  description = "Map of Managed Redis instances"
  type        = any
  default     = {}
}
