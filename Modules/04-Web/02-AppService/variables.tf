variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "web_app_name" {
  type = string
}

variable "app_settings" {
  type    = map(string)
  default = {}
}

variable "service_plan_id" {
  type = string
}

variable "subnet_id" {
  description = "The subnet ID to associate with the network interface"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to resources (inclusive)"
  type = object({
    environment = string
    project     = string
  })
}

variable "runtime" {
  description = "Provide only ONE runtime key at a time (dotnet_version, node_version, python_version)"
  type        = map(string)
  default     = {}
}
