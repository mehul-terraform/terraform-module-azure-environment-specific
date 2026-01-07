variable "postgre_sql" {
  description = "Map of PostgreSQL Flexible Servers"
  type        = map(any)
}

variable "location" {}
variable "resource_group_name" {}

# REQUIRED FOR FLEXIBLE SERVER PRIVATE ACCESS
variable "delegated_subnet_id" {}
variable "private_dns_zone_id" {}
variable "key_vault_id" {}
# variable "password_rotation_version" {}

variable "tags" {
  type    = map(string)
  default = {}
}
