variable "key_vault_name" {
  type        = string
  description = "The name of the Key Vault."
}

variable "location" {
  type        = string
  description = "Azure location where the Key Vault will be created."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
}

variable "object_id" {
  type        = string
  description = "The Object ID of the Azure AD user/service principal that will have access to the Key Vault."
}

variable "sku_name" {
  type        = string
  description = "SKU Name of the Key Vault. Possible values are 'standard' and 'premium'."
}

variable "soft_delete_retention_days" {
  type        = number
  description = "Number of days to retain soft deleted key vault objects."
}

variable "purge_protection_enabled" {
  type        = bool
  description = "Enable purge protection on the Key Vault."
}

variable "tags" {
  type        = map(string)
  description = "Tags to be applied to the Key Vault."
}

variable "secrets" {
  type = map(string)
}