variable "storage_account_name" {
  description = "Storage account name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "app_service_plan_name" {
  description = "App Service plan name"
  type        = string
}

variable "function_app_name" {
  description = "Function app name"
  type        = string
}

variable "identity_type" {
  description = "Managed identity type"
  type        = string
  default     = "SystemAssigned"
}

variable "function_app_extension_version" {
  description = "Function app extension version"
  type        = string
  default     = "~4"
}

variable "run_from_package" {
  description = "Enable run from package"
  type        = bool
  default     = true
}

variable "worker_runtime" {
  description = "Function runtime"
  type        = string
  default     = "node"
}

variable "linux_fx_version" {
  description = "Linux runtime stack, e.g. NODE|18"
  type        = string
  default     = "NODE|18"
}

variable "app_settings" {
  description = "Extra app settings as a map"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default     = {}
}

variable "node_version" {
  description = "Node.js version for the Function App"
  type        = string
  default     = "18"
}

variable "runtime_name" {
  description = "Function runtime"
  type        = string
  default     = "node"
}

variable "runtime_version" {
  description = "Function runtime"
  type        = string
  default     = "20"
}

variable "sku_name" {
  description = "Function sku name"
  type        = string
}

variable "os_type" {
  description = "Function os type"
  type        = string
}