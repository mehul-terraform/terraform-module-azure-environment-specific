variable "communication_service_name" {
  description = "The name of the Azure Communication Service."
  type        = string
}

variable "email_service_name" {
  description = "The name of the Email Communication Service."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "data_location" {
  description = "The data location for the Communication Services."
  type        = string
}

variable "domain_name" {
  description = "The custom domain name for the Email Communication Service."
  type        = string
}

variable "enable_user_engagement_tracking" {
  description = "Enable user engagement tracking for the Email Communication Service domain."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags for the resources."
  type        = map(string)
  default     = {}
}
