variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "service_plan_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "app_services" {
  type = map(object({
    web_app_name = string

    runtime = object({
      node_version   = optional(string)
      python_version = optional(string)
      dotnet_version = optional(string)
    })

    app_settings = map(string)
    tags         = map(string)
  }))
}