variable "resource_group_name" {
  type = string
}

variable "virtual_network_id" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "private_dns_zones" {
  type = map(object({
    name = string
  }))
}
