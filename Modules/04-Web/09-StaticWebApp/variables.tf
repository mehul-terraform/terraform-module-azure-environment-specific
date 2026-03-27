

variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
}

variable "static_web_apps" {
  description = "Map of Static Web Apps to create"
  type        = map(any)
}

variable "tags" {
  description = "Optional tags for Azure resources."
  type        = map(string)
  default     = {}
}
