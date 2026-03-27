variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "subnet_id" {
  description = "Global subnet ID for all apps in this module"
  type        = string
  default     = null
}

variable "function_apps" {
  type = map(object({
    function_app_name      = string
    service_plan_name      = string
    storage_account_name   = string
    storage_container_name = string
    runtime_name           = string
    runtime_version        = string
    os_type                = string
    sku_name               = optional(string)
    subnet_id              = optional(string)
    maximum_instance_count = optional(number)
    instance_memory_in_mb  = optional(number)
  }))
}

variable "managed_identity_id" {
  description = "The ID of the User Assigned Managed Identity."
  type        = string
}
