variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
}

variable "location" {
  description = "Azure Region"
  type        = string
}

variable "front_door_sku_name" {
  description = "Azure SKU"
  type        = string
}

variable "front_door_name" {
  description = "Azure Front Door Name"
  type        = string
}

variable "endpoint_frontend_name" {
  description = "backend domain"
  type        = string
}

variable "endpoint_backend_name" {
  description = "backend domain"
  type        = string
}

variable "origin_group_frontend_name" {
  description = "frontend-origin-group"
  type        = string
}

variable "origin_group_backend_name" {
  description = "backend-origin-group"
  type        = string
}

variable "origin_frontend_name" {
  description = "frontend_origin_name"
  type        = string
}

variable "origin_backend_name" {
  description = "backend_origin_name"
  type        = string
}

variable "route_frontend_name" {
  description = "frontend route"
  type        = string
}

variable "route_backend_name" {
  description = "backend route"
  type        = string
}

variable "origin_host_frontend_name" {
  description = "Frontend Domain"
  type        = string
}

variable "origin_host_backend_name" {
  description = "backend domain"
  type        = string
}

variable "host_custome_domain_frontend_name" {
  description = "Frontend Domain"
  type        = string
}

variable "host_custome_domain_backend_name" {
  description = "backend domain"
  type        = string
}

variable "custome_domain_frontend_name" {
  description = "Frontend Domain"
  type        = string
}

variable "custome_domain_backend_name" {
  description = "backend domain"
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
