variable "static_webapp_name" {
  description = "The name of the static web app."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
}

variable "location" {
  description = "Azure location for the resources."
  type        = string
}

variable "sku_tier" {
  description = "The SKU tier (e.g., Free, Standard)."
  type        = string  
}

variable "sku_size" {
  description = "The SKU size."
  type        = string 
}


variable "tags" {
  description = "Optional tags for Azure resources."
  type        = map(string)
  default     = {}
}
