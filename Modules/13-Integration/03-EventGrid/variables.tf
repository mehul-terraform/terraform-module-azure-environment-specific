variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "eventgrid_topics" {
  description = "Map of Event Grid Topics"
  type = map(object({
    name     = string
    tags     = optional(map(string), {})
    identity = optional(bool, false)
  }))
}

variable "eventgrid_subscriptions" {
  description = "Map of Event Grid Subscriptions"
  type = map(object({
    topic_key = string
    name      = string

    webhook_endpoint = optional(string)
    azure_function_id = optional(string)
    storage_queue_endpoint = optional(object({
      storage_account_id = string
      queue_name         = string
    }))

    included_event_types = optional(list(string))
    subject_begins_with  = optional(string)
    subject_ends_with    = optional(string)
  }))
  default = {}
}
