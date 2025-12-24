variable "private_endpoints" {
  description = "Resolved private endpoint configuration"
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    subnet_id           = string

    resource_id       = string
    subresource_names = list(string)

    private_dns_zone_ids = list(string)
    is_manual_connection = optional(bool, false)

    tags = optional(map(string), {})
  }))
}