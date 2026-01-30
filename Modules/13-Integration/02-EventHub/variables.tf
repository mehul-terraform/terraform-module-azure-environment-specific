variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location/region where the EventHub Namespace should be created"
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "eventhub_namespaces" {
  description = "Map of EventHub Namespaces and their configuration"
  type = map(object({
    name                     = string
    sku                      = optional(string, "Standard")
    capacity                 = optional(number, 1)
    auto_inflate_enabled     = optional(bool, false)
    maximum_throughput_units = optional(number, 0)
    zone_redundant           = optional(bool, false)
    tags                     = optional(map(string), {})

    eventhubs = optional(map(object({
      name              = string
      partition_count   = optional(number, 2)
      message_retention = optional(number, 1)
    })), {})
  }))
}
