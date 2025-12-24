variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "storage_accounts" {
  type = map(object({
    name                     = string
    account_tier             = string
    account_replication_type = string

    static_website = optional(object({
      index_document     = string
      error_404_document = string
    }))

    tags = optional(map(string), {})
  }))
}
