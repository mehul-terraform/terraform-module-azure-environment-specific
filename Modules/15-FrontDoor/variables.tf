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

variable "frontend_endpoint_name" {
  description = "backend domain"
  type        = string
}

variable "backend_endpoint_name" {
  description = "backend domain"
  type        = string
}

variable "frontend_origin_group_name" {
  description = "frontend-origin-group"
  type        = string
}

variable "backend_origin_group_name" {
  description = "backend-origin-group"
  type        = string
}

variable "frontend_origin_name" {
  description = "frontend_origin_name"
  type        = string
}

variable "backend_origin_name" {
  description = "backend_origin_name"
  type        = string
}

variable "frontend_route_name" {
  description = "frontend route"
  type        = string
}

variable "backend_route_name" {
  description = "backend route"
  type        = string
}

variable "frontend_domain_name" {
  description = "Frontend Domain"
  type        = string
}
 
variable "backend_domain_name" {
  description = "backend domain"
  type        = string
} 

variable "host_frontend_domain_name" {
  description = "Frontend Domain"
  type        = string
}
 
variable "host_backend_domain_name" {
  description = "backend domain"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to resources (inclusive)"
  type = object({
    environment = string
    project     = string
  })
}

variable "extra_tags" {
  description = "extra tags to be applied to resources (in addition to the tags above)"
  type        = map(string)
  default     = {}
}