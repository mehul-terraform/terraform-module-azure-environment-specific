variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "service_plan_ids" {
  type = map(string)
}

variable "subnet_id" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "app_service" {
  type = map(object({
    app_service_name = string
    service_plan_key = string

    runtime = object({
      node_version   = optional(string)
      python_version = optional(string)
      dotnet_version = optional(string)
    })

    app_settings = map(string)
    tags         = map(string)
  }))
}
