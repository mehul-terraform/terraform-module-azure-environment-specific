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

# Public IP Variables
variable "virtual_machine_public_ip_name" {
  description = "The name of the public IP resource"
  type        = string
}

variable "virtual_machine_public_ip_allocation_method" {
  description = "The name of the public IP resource"
  type        = string
}

# Network Interface Variables
variable "network_interface_name" {
  description = "The name of the network interface"
  type        = string
}

variable "private_ip_address_name" {
  description = "The static private IP address for the VM"
  type        = string
}

variable "private_ip_address" {
  description = "The static private IP address for the VM"
  type        = string
}

variable "private_ip_address_allocation" {
  description = "The static private IP address for the VM"
  type        = string
}

# Virtual Machine Variables
variable "virtual_machine_name" {
  description = "The name of the virtual machine"
  type        = string

}

variable "virtual_machine_size" {
  description = "The size of the virtual machine"
  type        = string
}

variable "admin_username" {
  description = "Admin username for the virtual machine"
  type        = string
}

variable "admin_password" {
  description = "Admin password for the virtual machine"
  type        = string
  sensitive   = true
}

# OS Disk Variables
variable "os_disk_caching" {
  description = "Specifies the caching requirements for the OS disk"
  type        = string
}

variable "os_disk_storage_account_type" {
  description = "The type of storage account to use for the OS disk"
  type        = string
}

# Image Reference Variables
variable "virtual_machine_image_publisher" {
  description = "Publisher of the OS image"
  type        = string
}

variable "virtual_machine_image_offer" {
  description = "Offer of the OS image"
  type        = string
}

variable "virtual_machine_image_sku" {
  description = "SKU of the OS image"
  type        = string
}

variable "virtual_machine_image_version" {
  description = "Version of the OS image"
  type        = string
}

#-----------------------------------------------------------------------------------------------
# 3.3-ContainerRegistry
#-----------------------------------------------------------------------------------------------

variable "container_registry_name" {
  description = "Name of the Azure Container Registry (lowercase letters and numbers only)"
  type        = string
}

variable "container_registry_sku" {
  description = "SKU of the container registry (Basic, Standard, Premium)"
  type        = string
}

variable "admin_enabled" {
  description = "Enable admin user for ACR"
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "Enable public network access"
  type        = bool
  default     = true
}

variable "quarantine_policy_enabled" {
  description = "Enable quarantine policy"
  type        = bool
  default     = true
}

variable "zone_redundancy_enabled" {
  description = "Enable zone redundancy"
  type        = bool
  default     = true
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
# 4.2-AppService
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

variable "static_webapp_name" {
  description = "The name of the static web app."
  type        = string
}

variable "static_webapp_location" {
  description = "Path to your application code relative to the repository root."
  type        = string
}

variable "static_webapp_api_location" {
  description = "Path to your Azure Functions API code."
  type        = string
  default     = ""
}

variable "static_webapp_sku_tier" {
  description = "The SKU tier (e.g., Free, Standard)."
  type        = string
}

variable "static_webapp_sku_size" {
  description = "The SKU size."
  type        = string
}

variable "static_webapp_output_location" {
  description = "Build output folder relative to app_location."
  type        = string
  default     = "build"
}

variable "static_webapp_repository_url" {
  type        = string
  description = "Repository URL for Static Web App"
}

variable "static_webapp_repository_branch" {
  type        = string
  description = "Branch name for Static Web App"
}

variable "static_webapp_repository_token" {
  type      = string
  sensitive = true
}

#-----------------------------------------------------------------------------------------------
# 4.5-FunctionApp
#-----------------------------------------------------------------------------------------------

variable "function_app_name" {
  type        = string
  description = "Function app name"
}

variable "dotnet_version" {
  type = string
}

variable "run_from_package" {
  type = string
}

variable "worker_runtime" {
  type = string
}

variable "function_app_node_version" {
  type = string
}

variable "function_app_extension_version" {
  type        = string
  description = "Extension Version"
}

variable "function_app_settings" {
  description = "App application settings"
  type        = map(any)
  default     = {}
}

variable "identity_type" {
  description = "The Managed Service Identity Type of this Virtual Machine."
  type        = string
  default     = ""
}

#---------------------------------------------------------------------------------------------
# 4.6-FunctionAppFlexConsumption
#---------------------------------------------------------------------------------------------

variable "function_app_flex_name" {
  type        = string
  description = "Function app name"
}

variable "function_app_flex_storage_account_name" {
  type        = string
  description = "Extension Version"
}

variable "function_app_flex_account_tier" {
  description = "Storage account tier name"
  type        = string
}

variable "function_app_flex_account_replication_type" {
  description = "Storage account replication type"
  type        = string
}

variable "function_app_flex_service_plan_name" {
  type        = string
  description = "Extension Version"
}

variable "function_app_flex_app_settings" {
  description = "App application settings"
  type        = map(any)
  default     = {}
}

variable "function_app_flex_runtime_name" {
  description = "The name of the language worker runtime."
  type        = string
}

variable "function_app_flex_runtime_version" {
  description = "The version of the language worker runtime."
  type        = string
}

variable "function_app_flex_sku_name" {
  description = "Function sku name"
  type        = string
}

variable "function_app_flex_os_type" {
  description = "Function os type"
  type        = string
}

variable "function_app_flex_container_access_type" {
  description = "Function containrer access type"
  type        = string
}

variable "function_app_flex_storage_container_name" {
  description = "storage container name"
  type        = string
}

variable "function_app_flex_identity_type" {
  description = "The Managed Service Identity Type of this Virtual Machine."
  type        = string
  default     = ""
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

variable "postgresql_flexible_server_name" {
  description = "A name which will be pre-pended to the resources created"
  type        = string

  validation {
    condition     = can(regex("^[0-9a-z][-0-9a-z]{1,61}[0-9a-z]$", var.postgresql_flexible_server_name))
    error_message = "The name can contain only lowercase letters, numbers, and '-', but can't start or end with '-'. And must be at least 3 characters and at most 63 characters."
  }
}

variable "postgres_sku_name" {
  type        = string
  description = "Specifies the SKU of the database"
}

variable "postgres_tier" {
  description = "Tier for PostgreSQL Flexible server sku : https://docs.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-compute-storage. Possible values are: GeneralPurpose, Burstable, MemoryOptimized."
  type        = string
  default     = "GeneralPurpose"
}

variable "storage_mb" {
  description = "Storage allowed for PostgresSQL Flexible server. Possible values : https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server#storage_mb."
  type        = number
  default     = null
}

variable "postgresql_version" {
  description = "Version of PostgreSQL Flexible Server. Possible values are : https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server#version."
  type        = number
  default     = 13
}

variable "zone" {
  description = "Specify availability-zone for PostgreSQL Flexible main Server."
  type        = number
  default     = 1
}

variable "standby_zone" {
  description = "Specify availability-zone to enable high_availability and create standby PostgreSQL Flexible Server. (Null to disable high-availability)"
  type        = number
  default     = null
}

variable "postgre_administrator_login" {
  description = "PostgreSQL administrator login."
  type        = string
}

variable "postgre_administrator_password" {
  description = "PostgreSQL administrator password. Strong Password : https://docs.microsoft.com/en-us/sql/relational-databases/security/strong-passwords?view=sql-server-2017."
  type        = string
}

variable "backup_retention_days" {
  description = "Backup retention days for the PostgreSQL Flexible Server (Between 7 and 35 days)."
  type        = number
  default     = 7
}

variable "geo_redundant_backup_enabled" {
  description = "Enable Geo Redundant Backup for the PostgreSQL Flexible Server."
  type        = bool
  default     = false
}

variable "maintenance_window" {
  description = "Map of maintenance window configuration."
  type        = map(number)
  default     = null
}

variable "private_dns_zone_id" {
  description = "ID of the private DNS zone to create the PostgreSQL Flexible Server."
  type        = string
  default     = null
}

variable "delegated_subnet_id" {
  description = "Id of the subnet to create the PostgreSQL Flexible Server. (Should not have any resource deployed in)"
  type        = string
  default     = null
}

variable "databases" {
  description = <<EOF
  Map of databases configurations with database name as key and following available configuration option:
   *  (optional) charset: Valid PostgreSQL charset : https://www.postgresql.org/docs/current/multibyte.html#CHARSET-TABLE
   *  (optional) collation: Valid PostgreSQL collation : http://www.postgresql.cn/docs/13/collation.html - be careful about https://docs.microsoft.com/en-us/windows/win32/intl/locale-names?redirectedfrom=MSDN
  EOF
  type = map(object({
    charset   = optional(string, "utf8")
    collation = optional(string, "en_US.utf8")
  }))
  default = {}
}

variable "postgresql_configurations" {
  description = "PostgreSQL configurations to enable."
  type        = map(string)
  default     = {}
}

variable "use_random_string" {
  description = "Flag to determine if a random string should be used for the database name and password"
  type        = bool
  default     = false
}

variable "allowed_cidrs" {
  description = "Map of authorized cidrs."
  type        = map(string)
  default     = {}
}

variable "create_key_secret" {
  description = "Map of key vault secrets to create"
  type = map(object({
    key_vault_id    = string
    content_type    = optional(string, null)
    expiration_date = optional(string, null)
    not_before_date = optional(string, null)
  }))
  default = {}
}

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

/*
variable "posgresql_private_endpoint_name" {
  description = "Private Endpoint name"
  type        = string
}

variable "storage_frontend_private_endpoint_name" {
  type = string
}

variable "app_service_frontend_private_endpoint_name" {
  type = string
}

variable "app_service_backend_private_endpoint_name" {
  type = string
}

variable "app_service_container_frontend_private_endpoint_name" {
  type = string
}

variable "app_service_container_backend_private_endpoint_name" {
  type = string
}

variable "keyvault_private_endpoint_name" {
  type = string
}

variable "private_endpoints" {
  description = "Logical private endpoint definitions"
  type = map(object({
    name              = string
    service           = string   # postgres | storage | webapp | keyvault
    subresource_names = list(string)
    tags              = optional(map(string), {})
  }))
}


/*
variable "private_endpoints" {
  description = "Private Endpoints configuration"
  type = map(any)
    
}
*/
/*
variable "private_endpoints" {
  description = "Private Endpoints configuration"
  type = map(object({
    name = string
    #location            = string
    #resource_group_name = string
    #subnet_id           = string

    #resource_id       = string
    #subresource_names = list(string)

    #private_dns_zone_ids = list(string)
    is_manual_connection = optional(bool, false)

    tags = optional(map(string), {})
  }))
}
*/
/*
variable "private_endpoints" {
  description = "Map of private endpoints"
  type = map(object({
    name = map(string)
    location            = string
    resource_group_name = string
    subnet_id           = string

    private_service_connection = object({
      name                           = string
      private_connection_resource_id = string
      subresource_names              = list(string)
      is_manual_connection           = bool
    })

    private_dns_zone_ids = list(string)

    tags = optional(map(string), {})
  }))
}
*/
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

variable "key_vault_name" {
  type        = string
  description = "The name of the Key Vault."
}

variable "key_vault_tenant_id" {
  type        = string
  description = "The Tenant ID for Azure AD."
}

variable "key_vault_object_id" {
  type        = string
  description = "The Object ID of the Azure AD user/service principal that will have access to the Key Vault."
}

variable "key_vault_sku_name" {
  type        = string
  description = "SKU Name of the Key Vault. Possible values are 'standard' and 'premium'."
}

variable "key_vault_soft_delete_retention_days" {
  type        = number
  description = "Number of days to retain soft deleted key vault objects."
}

variable "key_vault_purge_protection_enabled" {
  type        = bool
  description = "Enable purge protection on the Key Vault."
}

variable "key_vault_secrets" {
  type = map(string)
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

variable "servicebus_namespace_name" {
  type        = string
  description = "Name of the Service Bus namespace."
}

variable "servicebus_sku" {
  type        = string
  default     = "Standard"
  description = "Service Bus namespace SKU."
}

variable "servicebus_capacity" {
  type        = number
  default     = 1
  description = "Capacity, required for Premium SKU."
}

variable "servicebus_topic_name" {
  type        = string
  description = "Name of the Service Bus topic."
}

variable "servicebus_queue_name" {
  type        = string
  description = "Name of the Service Bus queue."
}

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