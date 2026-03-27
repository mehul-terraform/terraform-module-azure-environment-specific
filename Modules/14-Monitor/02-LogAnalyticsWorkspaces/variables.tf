variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "workspaces" {
  type = map(object({
    name              = string
    sku               = string
    retention_in_days = number
    tags              = optional(map(string), {})
  }))
}

variable "tags" {
  type    = map(string)
  default = {}
}
