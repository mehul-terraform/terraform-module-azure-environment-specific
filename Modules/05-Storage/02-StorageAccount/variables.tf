variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "storage_accounts" {
  description = "Storage accounts configuration"
  type = map(object({
    name                     = string
    account_tier             = string
    account_replication_type = string
    tags                     = optional(map(string), {})
  }))
}