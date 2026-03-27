variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "workspace_id" {
  type        = string
  description = "The ID of the Log Analytics Workspace to link to"
}

variable "app_insights" {
  type = map(object({
    name             = string
    application_type = string # e.g. "web", "other"
    tags             = optional(map(string), {})
  }))
}

variable "tags" {
  type    = map(string)
  default = {}
}
