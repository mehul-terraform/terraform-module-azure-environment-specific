variable "private_endpoints" {
  description = "Private Endpoint definitions"
  type = map(object({
    private_endpoint_name           = string
    location                        = string
    resource_group_name             = string
    subnet_id                       = string

    private_dns_zone_group_name     = string
    private_dns_zone_ids            = list(string)

    private_service_connection_name = string
    private_connection_resource_id  = string
    subresource_names               = list(string)
    is_manual_connection            = bool

    tags = optional(map(string), {})
  }))
}