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

variable "private_dns_zone_ids" {
  type = map(string)
}

variable "private_endpoints" {
  type = map(object({
    name                            = string
    subnet_id                       = string
    resource_id                     = string
    subresource_names               = list(string)
    private_service_connection_name = string
    private_dns_zone_key            = string
  }))
}