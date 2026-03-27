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

variable "app_service_container_windows" {
  type = map(object({
    app_service_container_name = string
    docker_image_name          = string
    service_plan_key           = string
    app_settings               = map(string)
    tags                       = map(string)
  }))
}

variable "managed_identity_id" {
  description = "The ID of the User Assigned Managed Identity."
  type        = string
}
