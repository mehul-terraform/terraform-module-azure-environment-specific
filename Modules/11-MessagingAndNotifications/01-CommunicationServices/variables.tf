variable "communication_services" {
  description = "Map of Communication Services to create"
  type        = map(any)
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "tags" {
  description = "Tags for the resources."
  type        = map(string)
  default     = {}
}

variable "enable_user_engagement_tracking" {
  description = "Enable user engagement tracking for the Email Communication Service domain."
  type        = bool
  default     = false
}


