variable "app_configurations" {
  description = "Map of App Configurations"
  type        = map(any)
}

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
