variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "cosmosdb_account_name" {
  description = "Cosmos DB account name"
  type        = string
}

variable "database_name" {
  description = "Cosmos DB SQL database name"
  type        = string
}

variable "consistency_level" {
  description = "Consistency level"
  type        = string
  default     = "Session"
  validation {
    condition     = contains(["Strong", "BoundedStaleness", "Session", "Eventual", "ConsistentPrefix"], var.consistency_level)
    error_message = "Must be one of Strong, BoundedStaleness, Session, Eventual, ConsistentPrefix."
  }
}

variable "max_interval_in_seconds" {
  description = "Max interval for bounded staleness"
  type        = number
  default     = 5
}

variable "max_staleness_prefix" {
  description = "Max staleness prefix for bounded staleness"
  type        = number
  default     = 100
}

variable "capabilities" {
  description = "Cosmos DB capabilities"
  type        = list(string)
  default     = []
}

variable "enable_automatic_failover" {
  description = "Enable automatic failover"
  type        = bool
  default     = false
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to be applied to the Key Vault."
}