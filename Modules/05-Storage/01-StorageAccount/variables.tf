variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "storage_account_name" {
  type = string
}

variable "account_tier" {
  type    = string
  default = "Standard"
}

variable "account_replication_type" {
  type    = string
  default = "LRS"
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "storage_account_index_document" {
  type        = string
  default     = "index.html"
  description = "The default index page for the static website"
}

variable "storage_account_error_404_document" {
  type        = string
  default     = "404.html"
  description = "The 404 error page for the static website"
}

