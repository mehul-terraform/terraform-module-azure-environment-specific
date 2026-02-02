
variable "front_doors" {
  description = "Map of Front Door profiles to create"
  type = map(object({
    front_door_name                   = string
    front_door_sku_name               = string
    endpoint_frontend_name            = string
    endpoint_backend_name             = string
    origin_group_frontend_name        = string
    origin_group_backend_name         = string
    origin_frontend_name              = string
    origin_backend_name               = string
    route_frontend_name               = string
    route_backend_name                = string
    origin_host_frontend_name         = string
    origin_host_backend_name          = string
    host_custome_domain_frontend_name = string
    host_custome_domain_backend_name  = string
    custome_domain_frontend_name      = string
    custome_domain_backend_name       = string
    minimum_tls_version               = optional(string, "TLS12")
    waf_policy_link_id                = optional(string)
    enable_waf                        = optional(bool, false)
    tags                              = optional(map(string), {})
  }))
}

variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
}

variable "location" {
  description = "Azure Region"
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
