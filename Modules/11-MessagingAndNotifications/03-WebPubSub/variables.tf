variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "web_pubsubs" {
  description = "Map of Web PubSub instances to create."
  type        = map(any)
}

variable "tags" {
  type    = map(string)
  default = {}
}
