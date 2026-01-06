variable "location" {
  type        = string
  description = "The Azure Region in which all resources in this example should be created."
}

variable "resource_group_name" {
  type        = string
  description = "The Azure Region in which all resources in this example should be created."
}

variable "tags" {
  description = "Map of tags to assign to resources."
  type        = map(string)
  default     = {}
}

variable "service_plans" {
  description = "App Service Plans (Linux + Windows)"
  type = map(object({
    name                     = string
    os_type                  = string   # "Linux" or "Windows"
    sku_name                 = string
    per_site_scaling_enabled = bool
    worker_count             = number
    tags                     = map(string)
  }))
}
