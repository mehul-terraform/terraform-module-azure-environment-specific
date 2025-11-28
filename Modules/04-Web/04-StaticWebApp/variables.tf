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

variable "repository_url" {
  description = "GitHub repo URL for the source code."
  type        = string
}

variable "repository_branch" {
  description = "Branch of the GitHub repo."
  type        = string

}

variable "repository_token" {
  type      = string
  sensitive = true
}

variable "app_location" {
  description = "Path to your application code relative to the repository root."
  type        = string
}

variable "api_location" {
  description = "Path to your Azure Functions API code."
  type        = string
}

variable "output_location" {
  description = "Build output folder relative to app_location."
  type        = string
}

variable "tags" {
  description = "Optional tags for Azure resources."
  type        = map(string)
  default     = {}
}
