variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location/region where the Notification Hub Namespace should be created"
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "notification_hub_namespaces" {
  description = "Map of Notification Hub Namespaces and their configuration"
  type = map(object({
    name = string
    sku  = optional(string, "Free") # Free, Basic, Standard
    tags = optional(map(string), {})

    notification_hubs = optional(map(object({
      name = string
      apns_credential = optional(object({
        application_mode = string
        bundle_id        = string
        team_id          = string
        token            = string
        key_id           = string
      }))
      gcm_credential = optional(object({
        api_key = string
      }))
    })), {})
  }))
}
