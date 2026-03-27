variable "subscription_id" {
  description = "The ID of the subscription where policies will be assigned."
  type        = string
}

variable "allowed_locations" {
  description = "List of allowed locations for resource deployment."
  type        = list(string)
  default     = null
}

variable "required_tags" {
  description = "Map of required tags to enforce on resources."
  type        = map(string)
  default     = {}
}
