variable "resource_group_name" {
  type        = string
  description = "The name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "key_vault_name" {
  type        = string
  description = "Globally unique key vault name"
}

variable "tenant_id" {
  type        = string
  description = "Azure AD tenant ID"
}

variable "object_id" {
  type        = string
  description = "Azure AD object ID for access policy"
}
