variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "function_apps" {
  description = "Map of Windows Function Apps to create"
  type = map(object({
    function_app_name    = string
    service_plan_name    = string
    storage_account_name = string
    sku_name             = optional(string, "Y1") # Y1=Consumption, B1/S1/P1v2 etc for dedicated
    runtime_stack        = string                 # "dotnet", "node", "java", "powershell"
    runtime_version      = string
    app_settings         = optional(map(string), {})
    always_on            = optional(bool, false)
    ftps_state           = optional(string, "Disabled")
    https_only           = optional(bool, true)
    tags                 = optional(map(string), {})
  }))
  default = {}
}
