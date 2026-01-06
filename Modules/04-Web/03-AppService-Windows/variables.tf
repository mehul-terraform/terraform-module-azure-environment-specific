variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
}

variable "service_plan_id" {
  description = "Windows App Service Plan ID"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for VNET integration"
  type        = string
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

variable "app_service_windows" {
  description = "Windows App Services configuration"
  type = map(object({
    app_service_name = string

    runtime = object({
      dotnet_version = optional(string)
      node_version   = optional(string)
      php_version    = optional(string)
    })

    app_settings = map(string)
    tags         = map(string)
  }))
}
