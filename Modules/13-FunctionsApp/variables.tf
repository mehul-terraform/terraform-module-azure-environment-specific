variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "Azure location"
}

variable "storage_account_name" {
  type        = string
  description = "Storage account name"
}

variable "app_service_plan_name" {
  type        = string
  description = "App Service plan name"
}

variable "function_app_name" {
  type        = string
  description = "Function app name"
}

variable "dotnet_version" {
  type        = string
  description = "Dotnet version"
  default     = "dotnet6"
}

variable "identity_type" {
  type        = string
  description = "Identity type"
  default     = "SystemAssigned"
}

variable "run_from_package" {
  type        = string
  description = "Run from package flag"
  default     = "1"
}

variable "worker_runtime" {
  type        = string
  description = "Functions runtime"
  default     = "dotnet"
}

variable "function_app_node_version" {
  type        = string
  description = "Node version"
  default     = "~14"
}

variable "app_settings" {
  type        = map(string)
  description = "Additional app settings"
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Tags"
  default     = {}
}

variable "storage_account_access_key" {
  type        = string
  description = "Tags"
}

