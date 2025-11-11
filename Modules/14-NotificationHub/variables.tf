variable "resource_group_name" {
  type = string
}

variable "location" {
  type    = string
  default = "East US"
}

variable "namespace_name" {
  type = string
}

variable "namespace_sku" {
  type    = string
  default = "Basic"
}

variable "notification_hub_name" {
  type = string
}
