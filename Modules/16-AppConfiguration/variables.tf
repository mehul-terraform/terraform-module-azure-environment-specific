variable "name" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "tags" { type = map(string) }

variable "key_values" {
  type = map(object({
    value = string
    label = optional(string)
  }))
  default = {}
}
