variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "tags" {
  description = "Tags to apply to the DNS zone."
  type        = map(string)
  default     = {}
}

variable "dns_zones" {
  description = "Map of DNS Zones and their records"
  type = map(object({
    name          = string
    cname_records = optional(map(string), {})
    txt_records   = optional(map(string), {})
    tags          = optional(map(string), {})
  }))
  default = {}
}
