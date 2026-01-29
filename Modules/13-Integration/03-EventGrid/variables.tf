variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "eventgrid_topics" {
  description = "Map of Event Grid Topics"
  type        = map(any)
}

variable "eventgrid_subscriptions" {
  description = "Map of Event Grid Subscriptions"
  type        = map(any)
  default     = {}
}
