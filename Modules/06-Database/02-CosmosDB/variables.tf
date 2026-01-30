variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "cosmos_dbs" {
  description = "Map of Cosmos DB accounts to create"
  type = map(object({
    name                    = string
    database_name           = string
    consistency_level       = optional(string, "Session")
    max_interval_in_seconds = optional(number, 5)
    max_staleness_prefix    = optional(number, 100)
    capabilities            = optional(list(string), [])
    tags                    = optional(map(string), {})
  }))
  default = {}
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to be applied to resources."
}
