variable "resource_groups" {
  description = "Map of Resource Groups to create"
  type        = map(any)
}

variable "tags" {
  description = "Tags to be applied to resources (inclusive)"
  type        = map(string)
  default     = {}
}

variable "extra_tags" {
  description = "extra tags to be applied to resources (in addition to the tags above)"
  type        = map(string)
  default     = {}
}
