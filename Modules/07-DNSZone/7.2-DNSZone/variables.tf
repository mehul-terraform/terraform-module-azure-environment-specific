variable "dns_zone_name" {
  description = "The name of the DNS zone."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "tags" {
  description = "Tags to apply to the DNS zone."
  type        = map(string)
  default     = {}
}

variable "cname_records" {
  type        = map(string)
  description = "Map of CNAME records: key = record name, value = target"
}

variable "txt_records" {
  description = "Map of TXT records to create"
  type        = map(string)
  default     = {}
}

