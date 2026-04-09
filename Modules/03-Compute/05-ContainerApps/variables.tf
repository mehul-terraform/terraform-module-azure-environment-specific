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

variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID"
  type        = string
}

variable "container_app_environments" {
  description = "Map of Container App Environments"
  type        = any
  default     = {}
}

variable "container_apps" {
  description = "Map of Container Apps"
  type        = any
  default     = {}
}
