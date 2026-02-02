#--------------------------------------------------------------------------------------------------
# Project Details
#--------------------------------------------------------------------------------------------------

variable "project" {
  description = "Project name prefix"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

#--------------------------------------------------------------------------------------------------
# 00-Tags
#--------------------------------------------------------------------------------------------------

variable "tags" {
  type    = map(string)
  default = {}
}

variable "extra_tags" {
  description = "Extra tags to merge"
  type        = map(string)
  default     = {}
}

#--------------------------------------------------------------------------------------------------
# 01-ResourceGroup
#--------------------------------------------------------------------------------------------------

variable "resource_groups" {
  description = "Map of Resource Groups to create"
  type        = map(any)
}

variable "waf_policies" {
  description = "Map of WAF Policies to create"
  type        = any
  default     = {}
}

#--------------------------------------------------------------------------------------------------
# 02-Networking
#--------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------
# 02.01-VirtualNetwork
#--------------------------------------------------------------------------------------------------

variable "virtual_networks" {
  description = "Map of Virtual Networks to create"
  type = map(object({
    name          = string
    address_space = list(string)
    tags          = optional(map(string), {})
    subnets = list(object({
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
  }))
  default = {}
}

#--------------------------------------------------------------------------------------------------
# 02.02-NetworkSecurityGroup
#--------------------------------------------------------------------------------------------------

variable "network_security_groups" {
  description = "Map of Network Security Groups to create"
  type        = map(any)
  default     = {}
}

#--------------------------------------------------------------------------------------------------
# 02.03-VirtualNetworkGateway
#--------------------------------------------------------------------------------------------------

variable "virtual_network_gateways" {
  description = "Map of Virtual Network Gateways to create"
  type = map(object({
    name                             = string
    public_ip_name                   = string
    public_ip_allocation_method      = optional(string, "Static")
    gateway_type                     = optional(string, "Vpn")
    vpn_type                         = optional(string, "RouteBased")
    active_active                    = optional(bool, false)
    sku                              = optional(string, "VpnGw1")
    default_local_network_gateway_id = optional(string)
    enable_bgp                       = optional(bool, false)
    generation                       = optional(string, "Generation1")
    private_ip_address_allocation    = optional(string, "Dynamic")
    bgp_settings = optional(object({
      asn         = number
      peer_weight = number
      peering_addresses = list(object({
        ip_configuration_name = optional(string)
        apipa_addresses       = list(string)
      }))
    }))
    vpn_client_configuration = optional(object({
      address_space = list(string)
      root_certificate = list(object({
        name             = string
        public_cert_data = string
      }))
      revoked_certificate = list(object({
        name       = string
        thumbprint = string
      }))
      radius_server_address = optional(string)
      radius_server_secret  = optional(string)
      vpn_client_protocols  = optional(list(string))
      vpn_auth_types        = optional(list(string))
    }))
    tags = optional(map(string), {})
  }))
  default = {}
}

#--------------------------------------------------------------------------------------------------
# 03-Compute
#--------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------
# 03.01-VirtualMachine
#--------------------------------------------------------------------------------------------------

variable "virtual_machines_windows" {
  description = "Map of Windows Virtual Machines to create"
  type        = map(any)
}

variable "virtual_machines_linux" {
  description = "Map of Linux Virtual Machines to create"
  type        = map(any)
  default     = {}
}

#--------------------------------------------------------------------------------------------------
# 03.02-ContainerRegistry
#--------------------------------------------------------------------------------------------------

variable "container_registries" {
  description = "Map of Container Registries to create"
  type        = map(any)
}

#--------------------------------------------------------------------------------------------------
# 04-Web
#--------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------
# 04.01-AppServicePlan
#--------------------------------------------------------------------------------------------------

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

#--------------------------------------------------------------------------------------------------
# 04.02-AppServiceLinux
#--------------------------------------------------------------------------------------------------

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

#--------------------------------------------------------------------------------------------------
# 04.03-AppServiceContainer
#--------------------------------------------------------------------------------------------------

variable "app_service_container" {
  type = map(object({
    app_service_container_name = string
    docker_image_name          = string
    app_settings               = map(string)
    tags                       = map(string)
  }))
}

#--------------------------------------------------------------------------------------------------
# 04.04-AppServiceWindows
#--------------------------------------------------------------------------------------------------

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

#--------------------------------------------------------------------------------------------------
# 04.05-StaticWebApp
#--------------------------------------------------------------------------------------------------

variable "static_web_apps" {
  description = "Map of Static Web Apps to create"
  type        = map(any)
}

#--------------------------------------------------------------------------------------------------
# 04.06-FunctionsAppLinux
#--------------------------------------------------------------------------------------------------

variable "function_apps_linux" {
  description = "Map of Linux Function Apps to create"
  type = map(object({
    function_app_name    = string
    service_plan_name    = string
    storage_account_name = string
    sku_name             = optional(string, "Y1")
    runtime_stack        = string # "dotnet", "node", "python", "java", "powershell"
    runtime_version      = string
    app_settings         = optional(map(string), {})
    always_on            = optional(bool, false)
    ftps_state           = optional(string, "Disabled")
    https_only           = optional(bool, true)
    tags                 = optional(map(string), {})
  }))
  default = {}
}

#--------------------------------------------------------------------------------------------------
# 04.07-FunctionsAppWindows
#--------------------------------------------------------------------------------------------------

variable "function_apps_windows" {
  description = "Map of Windows Function Apps to create"
  type = map(object({
    function_app_name    = string
    service_plan_name    = string
    storage_account_name = string
    sku_name             = optional(string, "Y1")
    runtime_stack        = string # "dotnet", "node", "java", "powershell"
    runtime_version      = string
    app_settings         = optional(map(string), {})
    always_on            = optional(bool, false)
    ftps_state           = optional(string, "Disabled")
    https_only           = optional(bool, true)
    tags                 = optional(map(string), {})
  }))
  default = {}
}

#--------------------------------------------------------------------------------------------------
# 04.08-FunctionsAppFlexConsumption
#--------------------------------------------------------------------------------------------------

variable "function_apps_flex" {
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

#--------------------------------------------------------------------------------------------------
# 05-StorageAccount
#--------------------------------------------------------------------------------------------------

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

#--------------------------------------------------------------------------------------------------
# 06-Database
#--------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------
# 06.01-PostgresSQLFlexible
#--------------------------------------------------------------------------------------------------

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

#--------------------------------------------------------------------------------------------------
# 06.02-CosmosDB
#--------------------------------------------------------------------------------------------------

variable "cosmos_dbs" {
  description = "Map of Cosmos DB accounts to create"
  type = map(object({
    name                      = string
    database_name             = string
    consistency_level         = optional(string, "Session")
    max_interval_in_seconds   = optional(number, 5)
    max_staleness_prefix      = optional(number, 100)
    capabilities              = optional(list(string), [])
    enable_automatic_failover = optional(bool, false)
    tags                      = optional(map(string), {})
  }))
  default = {}
}

#--------------------------------------------------------------------------------------------------
# 07-DNSZone
#--------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------
# 07.01-PrivateDNSZone
#--------------------------------------------------------------------------------------------------

variable "private_dns_zones" {
  description = "Private DNS Zones to create"
  type = map(object({
    name = string
  }))
}

#--------------------------------------------------------------------------------------------------
# 07.02-DNSZone
#--------------------------------------------------------------------------------------------------

variable "dns_zones" {
  description = "Map of DNS Zones and their records"
  type = map(object({
    name          = string
    cname_records = optional(map(string), {})
    txt_records   = optional(map(string), {})
    tags          = optional(map(string), {})
  }))
  default = {}
}

#--------------------------------------------------------------------------------------------------
# 08-PrivateEndPoints
#--------------------------------------------------------------------------------------------------

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

#--------------------------------------------------------------------------------------------------
# 09-CacheRedis
#--------------------------------------------------------------------------------------------------

variable "redis_caches" {
  description = "Map of Redis Caches to create"
  type = map(object({
    name                          = string
    capacity                      = number
    family                        = string
    sku                           = string
    enable_non_ssl_port           = optional(bool, false)
    minimum_tls_version           = optional(string, "1.2")
    cluster_shard_count           = optional(number, 0)
    private_static_ip_address     = optional(string)
    subnet_id                     = optional(string)
    public_network_access_enabled = optional(bool, true)
    redis_version                 = optional(string, "6")
    zones                         = optional(list(string), [])

    redis_configuration = optional(object({
      aof_backup_enabled              = optional(bool)
      aof_storage_connection_string_0 = optional(string)
      aof_storage_connection_string_1 = optional(string)

      maxmemory_reserved              = optional(number)
      maxmemory_delta                 = optional(number)
      maxmemory_policy                = optional(string)
      maxfragmentationmemory_reserved = optional(number)
      rdb_backup_enabled              = optional(bool)
      rdb_backup_frequency            = optional(number)
      rdb_backup_max_snapshot_count   = optional(number)
      rdb_storage_connection_string   = optional(string)
    }), null)

    patch_schedule = optional(map(object({
      day_of_week        = string
      start_hour_utc     = optional(number)
      maintenance_window = optional(string)
    })), {})

    tags = optional(map(string), {})
  }))
  default = {}
}

variable "redis_firewall_rules" {
  description = "Map of firewall rules for all Redis caches."
  type = map(object({
    redis_cache_key = string
    name            = string
    start_ip        = string
    end_ip          = string
  }))
  default = {}
}

#--------------------------------------------------------------------------------------------------
# 10-KeyVault
#--------------------------------------------------------------------------------------------------

variable "key_vaults" {
  description = "Map of Key Vaults to create"
  type        = map(any)
  default     = {}
}

#--------------------------------------------------------------------------------------------------
# 11-CommunicationServices
#--------------------------------------------------------------------------------------------------

variable "communication_services" {
  description = "Map of Communication Services to create"
  type        = map(any)
}

#--------------------------------------------------------------------------------------------------
# 12-NotificationsHub
#--------------------------------------------------------------------------------------------------

variable "notification_hub_namespaces" {
  description = "Map of Notification Hub Namespaces"
  type        = map(any)
}

#--------------------------------------------------------------------------------------------------
# 13-Integration
#--------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------
# 13.01-ServiceBus
#--------------------------------------------------------------------------------------------------

variable "service_buses" {
  type = map(any)
}

#--------------------------------------------------------------------------------------------------
# 13.02-EventHub
#--------------------------------------------------------------------------------------------------

variable "eventhub_namespaces" {
  type = map(any)
}

#--------------------------------------------------------------------------------------------------
# 13.03-EventGrid (commented)
#--------------------------------------------------------------------------------------------------

# variable "eventgrid_topics" {
#   type = map(any)
# }

# variable "eventgrid_subscriptions" {
#   type = map(any)
# }

#--------------------------------------------------------------------------------------------------
# 15-LoadBalancer
#--------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------
# 15.01-FrontDoor
#--------------------------------------------------------------------------------------------------

variable "front_doors" {
  description = "Map of Front Door profiles to create"
  type = map(object({
    front_door_name                   = string
    front_door_sku_name               = string
    endpoint_frontend_name            = string
    endpoint_backend_name             = string
    origin_group_frontend_name        = string
    origin_group_backend_name         = string
    origin_frontend_name              = string
    origin_backend_name               = string
    route_frontend_name               = string
    route_backend_name                = string
    origin_host_frontend_name         = string
    origin_host_backend_name          = string
    host_custome_domain_frontend_name = string
    host_custome_domain_backend_name  = string
    custome_domain_frontend_name      = string
    custome_domain_backend_name       = string
    waf_policy_link_id                = optional(string)
    enable_waf                        = optional(bool, false)
    tags                              = optional(map(string), {})
  }))
}

#--------------------------------------------------------------------------------------------------
# 16-AppConfiguration
#--------------------------------------------------------------------------------------------------

variable "app_configurations" {
  type = map(object({
    name = string
    key_values = optional(map(object({
      value = string
      label = optional(string)
    })), {})
  }))
}

#--------------------------------------------------------------------------------------------------
