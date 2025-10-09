# Define a variable for the resource group name
variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

# Define a variable for the location of resources
variable "location" {
  description = "The Azure region where the resource should be created"
  type        = string
}

# Define a variable for the private endpoint name
variable "private_endpoint_name" {
  description = "The name of the private endpoint"
  type        = string
}

# Define a variable for the virtual network ID where the private endpoint will be deployed
variable "virtual_network_id" {
  description = "The ID of the virtual network where the private endpoint will be deployed"
  type        = string
}

# Define a variable for the subnet ID where the private endpoint will be deployed
variable "private_endpoint_subnet_id" {
  description = "Subnet ID for the Private Endpoint"
  type        = string
}

# Define a variable for the private service connection name
variable "private_service_connection_name" {
  description = "The name for the private service connection"
  type        = string
}

# Define a variable for the resource ID of the private service (e.g., Azure SQL Database, Storage Account, etc.)
variable "private_connection_resource_id" {
  description = "The resource ID of the private service to connect to"
  type        = string
}

# Define a variable for the private DNS zone ID (optional if DNS integration is needed)
variable "private_dns_zone_id" {
  description = "The ID of the private DNS zone to integrate with"
  type        = string
  default     = null
}

# Define a variable for any optional tags
variable "tags" {
  description = "Tags for the Private Endpoint"
  type        = map(string)
  default     = {}

}

variable "extra_tags" {
  description = "extra tags to be applied to resources (in addition to the tags above)"
  type        = map(string)
  default     = {}
}

# Define a variable for the is manual connection  where the private endpoint will be deployed
variable "is_manual_connection" {
  description = "The ID of the subnet where the private endpoint will be deployed"
  type        = string
}

# Define a variable for the subresource names where the private endpoint will be deployed
variable "subresource_names" {
  description = "The ID of the subnet where the private endpoint will be deployed"
  type        = list(string)
}

# Define a variable for the private dns zone group name where the private endpoint will be deployed
variable "private_dns_zone_group_name" {
  description = "The ID of the subnet where the private endpoint will be deployed"
  type        = string
}

# Define a variable for the private_dns_zone_ids where the private endpoint will be deployed
variable "private_dns_zone_ids" {
  description = "The ID of the subnet where the private endpoint will be deployed"
  type        = list(string)
}