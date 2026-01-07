variable "storage_account_name" {
  description = "Storage account name"
  type        = string
}

variable "account_tier" {
  description = "Storage account tier name"
  type        = string
}

variable "account_replication_type" {
  description = "Storage account replication type"
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

variable "runtime_name" {
  description = "Function runtime"
  type        = string
}

variable "runtime_version" {
  description = "Function runtime"
  type        = string
}

variable "sku_name" {
  description = "Function sku name"
  type        = string
}

variable "os_type" {
  description = "Function os type"
  type        = string
}

variable "container_access_type" {
  description = "Function os type"
  type        = string
}

variable "storage_container_name" {
  description = "storage container name"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for VNET integration"
  type        = string
}
