variable "key_vaults" {
  description = "Map of Key Vaults to create"
  type        = map(any)
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
}

variable "tenant_id" {
  description = "The Azure Active Directory Tenant ID"
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
  default     = {}
}

variable "current_user_object_id" {
  description = "The Object ID of the user running Terraform"
  type        = string
  default     = null
}
