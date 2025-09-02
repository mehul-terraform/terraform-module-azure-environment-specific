#------------------------------------------------------------------------------------
# Tags

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
# 01-ResourceGroup

variable "location" {
  description = "Azure region for the virtual network"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

#----------------------------------------------------------------------------------------------
# 02-VirtualNetwork

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
  description = "List of subnets to create in the virtual network"
  type = list(object({
    name                              = string
    address_prefix                    = string
    private_endpoint_network_policies = optional(string)
    service_endpoints                 = optional(list(string))
  }))
}

#-----------------------------------------------------------------------------------------------
# 03-NetworkSecurityGroup

variable "network_security_group_name" {
  description = "The name of the Network Security Group."
  type        = string
}

variable "network_security_group_rules" {
  description                  = "List of security rules to apply to the NSG."
  type                         = list(object({
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
# 04-App Service Plan

variable "service_plan_name" {
  type        = string
  description = "The name of the App Service Plan"
  default     = null
}

variable "asp_os_type" {
  type        = string
  description = "OS type: Windows, Linux, or WindowsContainer"
  default     = "Linux"
}

variable "asp_sku_name" {
  type        = string
  description = "The SKU for the plan"
  default     = "P1v3"
}

variable "per_site_scaling_enabled" {
  type        = bool
  default     = false
  description = "Enable per site scaling"
}

variable "worker_count" {
  type        = number
  default     = null
  description = "Number of workers"
}

#-----------------------------------------------------------------------------------------------
# 05-AppService

variable "active_directory_auth_setttings" {
  description = "Active directory authentication provider settings for app service"
  type        = any
  default     = {}
}

variable "linux_web_app_name" {
  description = "The name of the function app"
  type        = string
  default     = null
}

variable "app_settings" {
  description = "Function App application settings"
  type        = map(any)
  default     = {}
}

variable "backup_sas_url" {
  description = "URL SAS to backup"
  type        = string
  default     = ""
}

variable "builtin_logging_enabled" {
  type        = bool
  description = "Whether AzureWebJobsDashboards should be enabled, default is true"
  default     = true
}

variable "client_certificate_enabled" {
  type        = bool
  description = "Whether client certificate auth is enabled, default is false"
  default     = false
}

variable "client_certificate_mode" {
  type        = string
  description = "The option for client certificates"
  default     = "Optional"
}

variable "connection_strings" {
  description = "Connection strings for App Service"
  type        = list(map(string))
  default     = []
}

variable "daily_memory_time_quota" {
  type        = number
  description = "The amount of memory in gigabyte-seconds that your app can consume per day, defaults to 0"
  default     = 0
}

variable "enabled" {
  type        = bool
  description = "Is the function app enabled? Default is true"
  default     = true
}

variable "force_disabled_content_share" {
  type        = bool
  description = "Should content share be disabled in storage account? Default is false"
  default     = false
}

variable "https_only" {
  description = "Disable http procotol and keep only https"
  type        = bool
  default     = true
}

variable "identity_ids" {
  description = "Specifies a list of user managed identity ids to be assigned to the VM."
  type        = list(string)
  default     = []
}

variable "identity_type" {
  description = "The Managed Service Identity Type of this Virtual Machine."
  type        = string
  default     = ""
}

variable "settings" {
  description = "Specifies the Authentication enabled or not"
  default     = false
  type        = any
}

variable "site_config" {
  description = "Site config for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#site_config. IP restriction attribute is not managed in this block."
  type        = any
  default     = {}
}

variable "storage_key_vault_secret_id" {
  type        = string
  description = "The secret ID for the connection string of the storage account used by the function app"
  default     = ""
}

variable "storage_uses_managed_identity" {
  type        = bool
  description = "If you want the storage account to use a managed identity instead of a access key"
  default     = false
}

variable "virtual_network_subnet_id" {
  description = "ID of the subnet to associate with the Function App (VNet integration)"
  type        = string
  default     = null
}

variable "docker_registry_url" {
  description = "URL of the Docker container registry (e.g. https://index.docker.io for Docker Hub)"
  type        = string
}

variable "docker_registry_username" {
  description = "Username for the Docker container registry"
  type        = string
  sensitive   = true
}

variable "docker_registry_password" {
  description = "Password for the Docker container registry"
  type        = string
  sensitive   = true
}

variable "docker_image_name" {
  description = "The name of the Docker image to deploy (e.g., nginx, myregistry.azurecr.io/myapp)"
  type        = string
}

variable "docker_image_tag" {
  description = "The tag of the Docker image to deploy (e.g., latest, v1.0.0)"
  type        = string
}

#------------------------------------------------------------------------------------------------
# 06-StorageAccount

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

variable "storage_account_index_document" {
  type    = string
  default = "index.html"
}

variable "storage_account_error_404_document" {
  type    = string
  default = "404.html"
}

#-----------------------------------------------------------------------------------------------
# 07-PostgresSQLFlexible

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
  default     = {}
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
  description       = "Map of key vault secrets to create"
  type              = map(object({
    key_vault_id    = string
    content_type    = optional(string, null)
    expiration_date = optional(string, null)
    not_before_date = optional(string, null)  
  }))
  default = {}
}
#-----------------------------------------------------------------------------------------
# 08-PrivateEndpoint

variable "private_endpoint_name" {
  description = "The name of the private endpoint"
  type        = string
}

variable "private_service_connection_name" {
  description = "The name for the private service connection"
  type        = string
}

variable "is_manual_connection" {
  description = "The ID of the subnet where the private endpoint will be deployed"
  type        = string
}

variable "subresource_names" {
  description = "The ID of the subnet where the private endpoint will be deployed"
  type        = list(string)
}

variable "private_dns_zone_group_name" {
  description = "The ID of the subnet where the private endpoint will be deployed"
  type        = string
}
#----------------------------------------------------------------------------------------
# 09-PrivateDNSZone

variable "private_dns_zone_name" {
  description = "Name of the private DNS zone"
  type        = string
}

variable "virtual_network_link_name" {
  description = "Name for the virtual network link"
  type        = string
}
#-----------------------------------------------------------------------------------------
# 10-RedisCache

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

variable "sku" {
  description = "The SKU of the Redis cache to deploy. Must be [Basic/Standard/Premium]"
  type        = string
}

variable "enable_non_ssl_port" {
  description = "Enable non-SSL port on Redis cache"
  type        = bool
  default = false
}

variable "minimum_tls_version" {
  description = "The minimum TLS version for the Redis cache"
  type        = string
  default = "1.0"
}

variable "cluster_shard_count" {
  description = "The number of shards for the Redis cache"
  type        = number
  default     = 0
}

variable "private_static_ip_address" {
  description = "The static IP address for the Redis cache"
  type        = string
  default = null
}

variable "subnet_id" {
  description = "The ID of the subnet in which the Redis cache is deployed"
  type        = string
  default = null
}

variable "redis_cache_public_network_access_enabled" {
  description = "Enable public network access for the Redis cache"
  type        = bool
  default = true
}

variable "redis_version" {
  description = "The version of Redis to deploy"
  type        = string
}

variable "zones" {
  description = "The availability zones in which to create the Redis cache"
  type        = list(string)
  default = []
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
  type        = map(object({
    name      = string
    count     = number
    start_ip  = string
    end_ip    = string
  }))
  description = "A map of firewall rules for the Redis cache."
  default = {}
}

#-----------------------------------------------------------------------------------------------
# 11-KeyVault

variable "key_vault_name" {
  type        = string
  description = "The name of the Key Vault."
}

variable "tenant_id" {
  type        = string
  description = "The Tenant ID for Azure AD."
}

variable "object_id" {
  type        = string
  description = "The Object ID of the Azure AD user/service principal that will have access to the Key Vault."
}

variable "key_vault_sku_name" {
  type        = string
  default     = "standard"
  description = "SKU Name of the Key Vault. Possible values are 'standard' and 'premium'."
}

variable "soft_delete_retention_days" {
  type        = number
  default     = 7
  description = "Number of days to retain soft deleted key vault objects."
}

variable "purge_protection_enabled" {
  type        = bool
  default     = true
  description = "Enable purge protection on the Key Vault."
}

#-----------------------------------------------------------------------------------------------
# 14-CommunicationServices

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

#-----------------------------------------------------------------------------------------------
# 15-FrontDoor

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

#-----------------------------------------------------------------------------------------------
# 16-VirtualMachine

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
  default     = "project-az-vm01"
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
  default     = "MicrosoftWindowsServer"
}

variable "virtual_machine_image_offer" {
  description = "Offer of the OS image"
  type        = string
  default     = "WindowsServer"
}

variable "virtual_machine_image_sku" {
  description = "SKU of the OS image"
  type        = string
  default     = "2016-Datacenter"
}

variable "virtual_machine_image_version" {
  description = "Version of the OS image"
  type        = string
  default     = "latest"
}

#-----------------------------------------------------------------------------------------------
# 17-ContainerRegistry

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

