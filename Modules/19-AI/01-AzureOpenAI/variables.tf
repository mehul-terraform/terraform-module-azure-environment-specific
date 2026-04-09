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

variable "openai_accounts" {
  description = "Map of OpenAI Cognitive Accounts"
  type        = any
  default     = {}
}

variable "openai_deployments" {
  description = "Map of OpenAI Model Deployments"
  type        = any
  default     = {}
}
