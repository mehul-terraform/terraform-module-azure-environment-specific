#------------------------------------------------------------------------------------
# Project Details
#------------------------------------------------------------------------------------
variable "project" {
  description = "Project name prefix"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

#------------------------------------------------------------------------------------
# 0-Tags
#------------------------------------------------------------------------------------

variable "tags" {
  type    = map(string)
  default = {}
}

variable "extra_tags" {
  description = "Extra tags to merge"
  type        = map(string)
  default     = {}
}

#----------------------------------------------------------------------------------------------
# 1-ResourceGroup
#----------------------------------------------------------------------------------------------

variable "location" {
  description = "Azure region for the virtual network"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

#----------------------------------------------------------------------------------------------
# 2.1-VirtualNetwork
#----------------------------------------------------------------------------------------------

variable "virtual_network_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
}

variable "dns_servers" {
  description = "DNS servers for the virtual network"
  type        = list(string)
  default     = []
}

variable "subnets" {
  description = "List of subnets to create"
  type = list(object({
    name           = string
    address_prefix = string
    delegation = optional(object({
      name = string
      service_delegation = object({
        name    = string
        actions = list(string)
      })
    }))
  }))
}

#-----------------------------------------------------------------------------------------------
# 2.2-NetworkSecurityGroup
#-----------------------------------------------------------------------------------------------

variable "network_security_group_name" {
  description = "The name of the Network Security Group."
  type        = string
}

variable "network_security_group_rules" {
  description = "List of security rules to apply to the NSG."
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = []
}

#-----------------------------------------------------------------------------------------------
# 2.3-VirtualNetworkGateway
#-----------------------------------------------------------------------------------------------

variable "virtual_network_gateway_name" {
  description = "Name of the virtual network gateway"
  type        = string

}

variable "gateway_type" {
  description = "Gateway type"
  type        = string

}

variable "vpn_type" {
  description = "VPN type"
  type        = string

}

variable "active_active" {
  description = "Active-active mode"
  type        = bool

}

variable "virtual_network_gateway_sku" {
  description = "Gateway SKU"
  type        = string

}

variable "virtual_network_gateway_public_ip_name" {
  description = "The name of the public IP resource"
  type        = string
}

variable "virtual_network_gateway_public_ip_allocation_method" {
  description = "Gateway SKU"
  type        = string

}

#-----------------------------------------------------------------------------------------------
# 3.1-VirtualMachine
#-----------------------------------------------------------------------------------------------

variable "virtual_machines" {
  description = "Map of Windows Virtual Machines to create"
  type        = map(any)
}

#-----------------------------------------------------------------------------------------------
# 3.3-ContainerRegistry
#-----------------------------------------------------------------------------------------------

variable "container_registries" {
  description = "Map of Container Registries to create"
  type        = map(any)
}

#-----------------------------------------------------------------------------------------------
# 4.1-AppServicePlan
#-----------------------------------------------------------------------------------------------

variable "service_plans" {
  description = "App Service Plans (Linux + Windows)"
  type = map(object({
    name                     = string
    os_type                  = string # "Linux" or "Windows"
    sku_name                 = string
    per_site_scaling_enabled = bool
    worker_count             = number
    tags                     = map(string)
  }))
}

#-----------------------------------------------------------------------------------------------
# 4.2-AppServiceLinux
#-----------------------------------------------------------------------------------------------

variable "app_service" {
  type = map(object({
    app_service_name = string

    runtime = object({
      node_version   = optional(string)
      python_version = optional(string)
      dotnet_version = optional(string)
    })

    app_settings = map(string)
    tags         = map(string)
  }))
}

#-----------------------------------------------------------------------------------------------

variable "app_service_windows" {
  description = "Windows Web Apps configuration"
  type = map(object({
    app_service_name = string

    runtime = object({
      dotnet_version = optional(string)
      node_version   = optional(string)
      php_version    = optional(string)
    })

    app_settings = map(string)
    tags         = map(string)
  }))
}

#-----------------------------------------------------------------------------------------------
# 4.3-AppServiceContainer
#-----------------------------------------------------------------------------------------------

variable "app_service_container" {
  type = map(object({
    app_service_container_name = string
    docker_image_name          = string
    app_settings               = map(string)
    tags                       = map(string)
  }))
}

#-----------------------------------------------------------------------------------------------
# 4.4-StaticWebApp
#-----------------------------------------------------------------------------------------------

variable "static_web_apps" {
  description = "Map of Static Web Apps to create"
  type        = map(any)
}

#-----------------------------------------------------------------------------------------------
# 4.5-FunctionApp
#-----------------------------------------------------------------------------------------------

# variable "function_app_name" {
#   type        = string
#   description = "Function app name"
# }

# variable "dotnet_version" {
#   type = string
# }

# variable "run_from_package" {
#   type = string
# }

# variable "worker_runtime" {
#   type = string
# }

# variable "function_app_node_version" {
#   type = string
# }

# variable "function_app_extension_version" {
#   type        = string
#   description = "Extension Version"
# }

# variable "function_app_settings" {
#   description = "App application settings"
#   type        = map(any)
#   default     = {}
# }

# variable "identity_type" {
#   description = "The Managed Service Identity Type of this Virtual Machine."
#   type        = string
#   default     = ""
# }

#---------------------------------------------------------------------------------------------
# 4.6-FunctionAppFlexConsumption
#---------------------------------------------------------------------------------------------

variable "function_apps" {
  type = map(object({
    function_app_name      = string
    service_plan_name      = string
    storage_account_name   = string
    storage_container_name = string
    runtime_name           = string
    runtime_version        = string
    os_type                = string
    subnet_id              = optional(string)
    maximum_instance_count = optional(number)
    instance_memory_in_mb  = optional(number)
  }))
}

#----------------------------------------------------------------------------------------------
# 5.2-StorageAccount
#----------------------------------------------------------------------------------------------

variable "storage_accounts" {
  type = map(object({
    name                     = string
    account_tier             = string
    account_replication_type = string

    static_website = optional(object({
      index_document     = string
      error_404_document = string
    }))

    tags = optional(map(string), {})
  }))
}

#-----------------------------------------------------------------------------------------------
# 6.1-PostgresSQLFlexible
#-----------------------------------------------------------------------------------------------

variable "postgres_sql" {
  type = map(object({
    name                         = string
    sku_name                     = string
    version                      = string
    storage_mb                   = number
    zone                         = string
    tier                         = string
    admin_login                  = string
    backup_retention_days        = number
    geo_redundant_backup_enabled = bool

    standby_zone = optional(string)

    maintenance_window = optional(object({
      day_of_week  = number
      start_hour   = number
      start_minute = number
    }))

    databases = map(object({
      charset   = string
      collation = string
    }))

    tags = optional(map(string), {})
  }))
}

# variable "password_rotation_version" {
#   description = "Global PostgreSQL admin password rotation version"
#   type        = string
#   default     = "v1"
# }


#-----------------------------------------------------------------------------------------------
# 6.2-CosmosDB
#-----------------------------------------------------------------------------------------------

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
}

variable "max_interval_in_seconds" {
  description = "Max interval for bounded staleness"
  type        = number
  default     = 5
}

variable "max_staleness_prefix" {
  description = "Max staleness prefix"
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

#-----------------------------------------------------------------------------------------------
# 7.1-PrivateDNSZone
#-----------------------------------------------------------------------------------------------
variable "private_dns_zones" {
  description = "Private DNS Zones to create"
  type = map(object({
    name = string
  }))
}

#-----------------------------------------------------------------------------------------------
# 7.2-DNSZone
#-----------------------------------------------------------------------------------------------

variable "dns_zone_name" {
  description = "The name of the DNS zone."
  type        = string
}

variable "cname_records" {
  type        = map(string)
  description = "Map of CNAME records: key = record name, value = target"
}

variable "txt_records" {
  type        = map(string)
  description = "TXT records: key = record name, value = TXT value"
  default     = {}
}

#-----------------------------------------------------------------------------------------------
# 8.1-PrivateEndPoint
#-----------------------------------------------------------------------------------------------

variable "private_endpoints" {
  description = "Logical private endpoint definitions"
  type = map(object({
    name              = string
    service           = string           # postgres | storage | webapp | webapp_container | keyvault
    instance          = optional(string) # frontend | backend | etc (required for webapp*)
    subresource_names = list(string)
    tags              = optional(map(string), {})
  }))

  validation {
    condition = alltrue([
      for v in var.private_endpoints :
      (v.service != "webapp" && v.service != "webapp-container")
      || v.instance != null
    ])
    error_message = "instance is required when service = webapp or webapp_container"
  }
}

#-----------------------------------------------------------------------------------------
# 9-RedisCache
#-----------------------------------------------------------------------------------------

variable "cache_name" {
  description = "The name of the Redis cache instance"
  type        = string
}

variable "capacity" {
  description = "The size of the Redis cache to deploy"
  type        = number
}

variable "family" {
  description = "The family of the Redis cache to deploy"
  type        = string
}

variable "redis_cache_sku" {
  description = "The SKU of the Redis cache to deploy. Must be [Basic/Standard/Premium]"
  type        = string
}

variable "enable_non_ssl_port" {
  description = "Enable non-SSL port on Redis cache"
  type        = bool
  default     = false
}

variable "minimum_tls_version" {
  description = "The minimum TLS version for the Redis cache"
  type        = string
  default     = "1.0"
}

variable "cluster_shard_count" {
  description = "The number of shards for the Redis cache"
  type        = number
  default     = 0
}

variable "private_static_ip_address" {
  description = "The static IP address for the Redis cache"
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "The ID of the subnet in which the Redis cache is deployed"
  type        = string
  default     = null
}

variable "redis_cache_public_network_access_enabled" {
  description = "Enable public network access for the Redis cache"
  type        = bool
  default     = true
}

variable "redis_version" {
  description = "The version of Redis to deploy"
  type        = string
}

variable "zones" {
  description = "The availability zones in which to create the Redis cache"
  type        = list(string)
  default     = []
}

variable "redis_configurations" {
  description = "A map of Redis configurations."
  type = map(object({
    aof_backup_enabled              = optional(bool)
    aof_storage_connection_string_0 = optional(string)
    aof_storage_connection_string_1 = optional(string)
    enable_authentication           = optional(bool)
    maxmemory_reserved              = optional(number)
    maxmemory_delta                 = optional(number)
    maxmemory_policy                = optional(string)
    maxfragmentationmemory_reserved = optional(number)
    rdb_backup_enabled              = optional(bool)
    rdb_backup_frequency            = optional(number)
    rdb_backup_max_snapshot_count   = optional(number)
    rdb_storage_connection_string   = optional(string)
  }))
  default = {}
}

variable "patch_schedule" {
  description = "A map of patch schedule settings for the Redis cache."
  type = map(object({
    day_of_week        = string
    start_hour_utc     = optional(number)
    maintenance_window = optional(string)
  }))
  default = {}
}

variable "redis_firewall_rule" {
  type = map(object({
    name     = string
    count    = number
    start_ip = string
    end_ip   = string
  }))
  description = "A map of firewall rules for the Redis cache."
  default     = {}
}

#-----------------------------------------------------------------------------------------------
# 10-KeyVault
#-----------------------------------------------------------------------------------------------

variable "key_vaults" {
  description = "Map of Key Vaults to create"
  type        = map(any)
  default     = {}
}

#-----------------------------------------------------------------------------------------------
# 11-CommunicationServices
#-----------------------------------------------------------------------------------------------

variable "communication_service_name" {
  description = "The name of the Azure Communication Service."
  type        = string
}

variable "email_service_name" {
  description = "The name of the Email Communication Service."
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

#-------------------------------------------------------------------------------------------------
# 13.1 ServiceBus
#-------------------------------------------------------------------------------------------------

variable "service_buses" {
  description = "Map of Service Bus Namespaces"
  type        = map(any)
}

#-----------------------------------------------------------------------------------------------
# 13.3-EventGrid

# variable "eventgrid_topics" {
#   type = map(any)
# }

# variable "eventgrid_subscriptions" {
#   type = map(any)
# }

#-----------------------------------------------------------------------------------------------
# 15.1-FrontDoor
#-----------------------------------------------------------------------------------------------

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

#----------------------------------------------------------------------------------------------
# 16-AppConfiguration
#----------------------------------------------------------------------------------------------

variable "app_configurations" {
  type = map(object({
    name = string
    key_values = optional(map(object({
      value = string
      label = optional(string)
    })), {})
  }))
}

#----------------------------------------------------------------------------------------------



#------------------------------------------------------------------------------------------------------
