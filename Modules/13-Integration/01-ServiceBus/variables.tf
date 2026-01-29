variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "service_buses" {
  description = "Map of Service Bus Namespaces, Topics, and Queues to create."
  type        = map(any)
}

variable "tags" {
  type    = map(string)
  default = {}
}
