#---------------------------------------------------------------------------------------------------
# 00-Provider

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = "339e9158-9454-4c79-a362-c37d1f2469a2"
  #skip_provider_registration = true
  #  subscription_id = "c09e0f60-cb15-4c23-8500-eeae1ec9dd6b" # "az account show --query id -o tsv"
}

#--------------------------------------------------------------------------------------------------
# 01-ResourceGroup

module "resource_group" {
  source              = "../../Modules/01-ResourceGroup"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = local.tags
}

#--------------------------------------------------------------------------------------------------
# 02-VirtualNetwork

module "virtual_network" {
  source               = "../../Modules/02-Networking/01-VirtualNetwork"
  resource_group_name  = module.resource_group.name
  location             = module.resource_group.location
  virtual_network_name = var.virtual_network_name
  address_space        = var.address_space
  subnets              = var.subnets
  tags                 = local.tags
}

#--------------------------------------------------------------------------------------------------
# 03-NetworkSecurityGroup

module "network_security_group" {
  source                       = "../../Modules/02-Networking/02-NetworkSecurityGroup"
  resource_group_name          = module.resource_group.name
  location                     = module.resource_group.location
  network_security_group_name  = var.network_security_group_name
  network_security_group_rules = var.network_security_group_rules
  vm_subnet_id                 = module.virtual_network.vm_subnets["vm"]
  db_subnet_id                 = module.virtual_network.db_subnets["db"]
  tags                         = local.tags
}

#--------------------------------------------------------------------------------------------------
# 04-AppServicePlan

module "service_plan" {
  source              = "../../Modules/04-Web/01-AppServicePlan"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  service_plan_name   = var.service_plan_name
  asp_os_type         = var.asp_os_type
  asp_sku_name        = var.asp_sku_name
  tags                = local.tags
}

#--------------------------------------------------------------------------------------------------
# 05-AppService

module "app_service" {
  source = "../../Modules/04-Web/02-AppService"

  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  service_plan_id     = module.service_plan.id
  web_app_name        = var.web_app_name
  runtime             = var.web_app_runtime
  subnet_id           = module.virtual_network.webapp_subnets["webapp"]
  app_settings        = var.app_settings
  tags                = local.tags
}

#resource "azurerm_app_service_virtual_network_swift_connection" "app_service_vnet_integration" {
#  app_service_id = module.app_service.id
#  subnet_id      = module.virtual_network.webapp_subnets["webapp"]
#}

#---------------------------------------------------------------------------------------------------
# 06-AppServiceContainer

module "app_service_container" {
  source = "../../Modules/04-Web/03-AppServiceContainer"

  resource_group_name    = module.resource_group.name
  location               = module.resource_group.location
  service_plan_id        = module.service_plan.id
  web_app_container_name = var.web_app_container_name
  subnet_id              = module.virtual_network.webapp_subnets["webapp"]
  app_settings           = var.app_settings
  docker_image_name      = var.docker_image_name
  tags                   = local.tags
}


#--------------------------------------------------------------------------------------------------
# 07-StorageAccountStaticWebSite

module "storage_account_website" {
  source                             = "../../Modules/05-Storage/01-StorageAccountStaticWebsite"
  resource_group_name                = module.resource_group.name
  location                           = module.resource_group.location
  storage_account_name               = var.storage_account_web_name
  account_tier                       = var.account_tier
  account_replication_type           = var.account_replication_type
  storage_account_index_document     = var.storage_account_index_document
  storage_account_error_404_document = var.storage_account_error_404_document
  tags                               = local.tags
}

#--------------------------------------------------------------------------------------------------
# 05.1-StorageAccount
/*
module "storage_account" {
  source                   = "../../Modules/05-Storage/02-StorageAccount"
  resource_group_name      = module.resource_group.name
  location                 = module.resource_group.location
  storage_account_name     = var.storage_account_name
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  tags                     = local.tags
}
*/
#--------------------------------------------------------------------------------------------------
# 08-PostgresSQLFlexible
/*
module "postgre_sql" {
  source                          = "../../Modules/06-Database/01-PostgreSQLFlexible"
  resource_group_name             = module.resource_group.name
  location                        = module.resource_group.location
  postgresql_flexible_server_name = var.postgresql_flexible_server_name
  postgres_sku_name               = var.postgres_sku_name
  storage_mb                      = var.storage_mb
  databases                       = var.databases
  postgre_administrator_login     = var.postgre_administrator_login
  postgre_administrator_password  = var.postgre_administrator_password
  tags                            = local.tags
}
*/
#--------------------------------------------------------------------------------------------------
# 09.1-PrivateEndPoint (PostgresSQLFelxible) 
/*
module "private_endpoint_postgres_flexible" {
  source                          = "../../Modules/08-PrivateEndPoint/8.1-PostgresSQLFlexible"
  private_endpoint_name           = var.private_endpoint_name
  private_dns_zone_ids            = [module.private_dns_zone.id]
  virtual_network_id              = module.virtual_network.id
  private_dns_zone_group_name     = var.private_dns_zone_group_name
  location                        = module.resource_group.location
  resource_group_name             = module.resource_group.name
  private_endpoint_subnet_id      = module.virtual_network.db_subnets["db"]
  private_service_connection_name = var.private_service_connection_name
  private_connection_resource_id  = module.postgre_sql.postgresql_flexible_server_id
  is_manual_connection            = var.is_manual_connection
  subresource_names               = var.subresource_names
  tags                            = local.tags
}
*/
#--------------------------------------------------------------------------------------------------
# 09.1-PrivateEndPoint (StorageAccount) 
/*
module "private_endpoint_storage_account" {
  source                          = "../../Modules/08-PrivateEndPoint/8.2-StorageAccount"
  private_endpoint_name           = var.storage_account_private_endpoint_name
  private_dns_zone_ids            = [module.private_dns_zone_storage_account.id]
  virtual_network_id              = module.virtual_network.id
  private_dns_zone_group_name     = var.storage_account_private_dns_zone_group_name
  location                        = module.resource_group.location
  resource_group_name             = module.resource_group.name
  private_endpoint_subnet_id      = module.virtual_network.storage_subnets["storage"]
  private_service_connection_name = var.storage_account_private_service_connection_name
  private_connection_resource_id  = module.storage_account.id
  is_manual_connection            = var.storage_account_is_manual_connection
  subresource_names               = var.storage_account_subresource_names
  tags                            = local.tags
}
*/
#--------------------------------------------------------------------------------------------------
# 10-PrivateDNSZonePostgresSQLFlexible
/*
module "private_dns_zone" {
  source                    = "../../Modules/07-DNSZone/7.1-PrivateDNSZone/7.1.1-PrivateDNSZonePostgresSQLFlexible"
  private_dns_zone_name     = var.private_dns_zone_group_name
  resource_group_name       = module.resource_group.name
  location                  = module.resource_group.location
  virtual_network_link_name = var.virtual_network_link_name
  virtual_network_id        = module.virtual_network.id
  tags                      = local.tags
}
*/
#-------------------------------------------------------------------------------------------------
# 10-PrivateDNSZoneStorageAccount
/*
module "private_dns_zone_storage_account" {
  source                    = "../../Modules/07-DNSZone/7.1-PrivateDNSZone/7.1.2-PrivateDNSZoneStorageAccount"
  private_dns_zone_name     = var.storage_account_private_dns_zone_group_name
  resource_group_name       = module.resource_group.name
  location                  = module.resource_group.location
  virtual_network_link_name = var.storage_account_virtual_network_link_name
  virtual_network_id        = module.virtual_network.id
  tags                      = local.tags
}
*/
#--------------------------------------------------------------------------------------------------
# 11-CacheRedis
/*
module "redis" {
  source                        = "../../Modules/09-CacheRedis"
  cache_name                    = var.cache_name
  location                      = module.resource_group.location
  resource_group_name           = module.resource_group.name
  capacity                      = var.capacity
  family                        = var.family
  sku                           = var.redis_cache_sku
  public_network_access_enabled = var.public_network_access_enabled
  redis_version                 = var.redis_version
  enable_non_ssl_port           = var.enable_non_ssl_port
  minimum_tls_version           = var.minimum_tls_version
  cluster_shard_count           = var.cluster_shard_count
  tags                          = local.tags
}
*/
#--------------------------------------------------------------------------------------------
# 12-KeyVault
/*
module "keyvault" {
  source                     = "../../Modules/10-KeyVault"
  resource_group_name        = module.resource_group.name
  location                   = module.resource_group.location
  key_vault_name             = var.key_vault_name
  tenant_id                  = var.key_vault_tenant_id
  object_id                  = var.key_vault_object_id
  sku_name                   = var.key_vault_sku_name
  purge_protection_enabled   = var.key_vault_purge_protection_enabled
  soft_delete_retention_days = var.key_vault_soft_delete_retention_days
  secrets                    = var.key_vault_secrets
  tags                       = local.tags
}
*/
#---------------------------------------------------------------------------------------------
# 13-CosmosDB
/*
module "cosmosdb" {
  source                    = "../../Modules/06-Database/02-CosmosDB"
  resource_group_name       = module.resource_group.name
  location                  = module.resource_group.location
  cosmosdb_account_name     = var.cosmosdb_account_name
  database_name             = var.database_name
  consistency_level         = var.consistency_level
  max_interval_in_seconds   = var.max_interval_in_seconds
  max_staleness_prefix      = var.max_staleness_prefix
  capabilities              = var.capabilities
  enable_automatic_failover = var.enable_automatic_failover
  tags                      = local.tags
}
*/
#--------------------------------------------------------------------------------------------------
# 14-FunctionsApp
/*
module "function_app" {
  source              = "../../Modules/04-Web/05-Functionsapp"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location

  storage_account_name       = module.storage_account.name
  storage_account_access_key = module.storage_account.access_key

  app_service_plan_name = module.service_plan.id
  function_app_name     = var.function_app_name

  dotnet_version                 = var.dotnet_version
  identity_type                  = var.identity_type
  run_from_package               = var.run_from_package
  worker_runtime                 = var.worker_runtime
  function_app_node_version      = var.function_app_node_version
  function_app_extension_version = var.function_app_extension_version
  app_settings                   = var.app_settings
  tags                           = var.tags
}

#resource "azurerm_app_service_virtual_network_swift_connection" "function_app_vnet_integration" {
#  app_service_id = module.function_app.id
#  subnet_id      = module.virtual_network.funcapp_subnets["funcapp"]
#}
*/
#--------------------------------------------------------------------------------------------------
# 14-FunctionsAppFlexConsumption
/*
module "function_app_flex" {
  source                   = "../../Modules/04-Web/06-FunctionsAppFlexConsumption"
  resource_group_name      = module.resource_group.name
  location                 = module.resource_group.location
  app_service_plan_name    = var.function_app_flex_service_plan_name
  storage_account_name     = var.function_app_flex_storage_account_name
  account_tier             = var.function_app_flex_account_tier
  account_replication_type = var.function_app_flex_account_replication_type
  function_app_name        = var.function_app_flex_name
  runtime_name             = var.function_app_flex_runtime_name
  runtime_version          = var.function_app_flex_runtime_version
  container_access_type    = var.function_app_flex_container_access_type
  storage_container_name   = var.function_app_flex_storage_container_name
  sku_name                 = var.function_app_flex_sku_name
  os_type                  = var.function_app_flex_os_type

  identity_type = var.function_app_flex_identity_type
  app_settings  = var.function_app_flex_app_settings
  tags          = var.tags
}

resource "azurerm_app_service_virtual_network_swift_connection" "function_app_vnet_integration" {
  app_service_id = module.function_app_flex.id
  subnet_id      = module.virtual_network.funcapp_subnets["funcapp"]
}
*/
#--------------------------------------------------------------------------------------------------
# 15-CommunicationsService
/*
module "communication_services" {
  source                          = "../../Modules/11-CommunicationServices"
  communication_service_name      = var.communication_service_name
  email_service_name              = var.email_service_name
  domain_name                     = var.domain_name
  enable_user_engagement_tracking = var.enable_user_engagement_tracking
  resource_group_name             = module.resource_group.name
  data_location                   = var.data_location
  tags                            = local.tags
}
*/
#--------------------------------------------------------------------------------------------------
# 16-FrontDoorStandard

module "azure_front_door" {
  source              = "../../Modules/15-LoadBalancer/01-FrontDoor"
  front_door_name     = var.front_door_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  front_door_sku_name = var.front_door_sku_name

  endpoint_frontend_name = var.endpoint_frontend_name
  endpoint_backend_name  = var.endpoint_backend_name

  origin_group_frontend_name = var.origin_group_frontend_name
  origin_group_backend_name  = var.origin_group_backend_name

  origin_frontend_name = var.origin_frontend_name
  origin_backend_name  = var.origin_backend_name

  origin_host_frontend_name = replace(
    replace(module.storage_account_website.static_website_url, "https://", ""),
    "/", ""
  )
  origin_host_backend_name = module.app_service_container.app_service_container_default_hostname

  custome_domain_frontend_name = var.custome_domain_frontend_name
  custome_domain_backend_name  = var.custome_domain_backend_name

  host_custome_domain_frontend_name = var.host_custome_domain_frontend_name
  host_custome_domain_backend_name  = var.host_custome_domain_backend_name

  route_frontend_name = var.route_frontend_name
  route_backend_name  = var.route_backend_name

  tags = local.tags
}

#--------------------------------------------------------------------------------------------------------------
# 17-VirtualMachine
/*
module "virtual_machine" {
  source                          = "../../Modules/03-Compute/01-VirtualMachine"
  resource_group_name             = module.resource_group.name
  location                        = module.resource_group.location
  virtual_machine_name            = var.virtual_machine_name
  virtual_machine_size            = var.virtual_machine_size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  network_interface_name          = var.network_interface_name
  subnet_id                       = module.virtual_network.vm_subnets["vm"]
  private_ip_address_allocation   = var.private_ip_address_allocation
  private_ip_address              = var.private_ip_address
  private_ip_address_name         = var.private_ip_address_name
  virtual_machine_public_ip_name  = var.virtual_machine_public_ip_name
  public_ip_allocation_method     = var.virtual_machine_public_ip_allocation_method
  os_disk_caching                 = var.os_disk_caching
  os_disk_storage_account_type    = var.os_disk_storage_account_type
  virtual_machine_image_publisher = var.virtual_machine_image_publisher
  virtual_machine_image_offer     = var.virtual_machine_image_offer
  virtual_machine_image_sku       = var.virtual_machine_image_sku
  virtual_machine_image_version   = var.virtual_machine_image_version
  tags                            = local.tags
}
*/
#--------------------------------------------------------------------------------------------------
# 18-ContainerRegistry
/*
module "container_registry" {
  source                        = "../../Modules/03-Compute/02-ContainerRegistry"
  container_registry_name       = var.container_registry_name
  resource_group_name           = module.resource_group.name
  location                      = module.resource_group.location
  container_registry_sku        = var.container_registry_sku
  admin_enabled                 = var.admin_enabled
  public_network_access_enabled = var.public_network_access_enabled
  quarantine_policy_enabled     = var.quarantine_policy_enabled
  zone_redundancy_enabled       = var.zone_redundancy_enabled
  tags                          = local.tags
}
*/
#--------------------------------------------------------------------------------------------------
# 20-VirtualNetworkGateway
/*
module "virtual_network_gateway" {
  source                       = "../../Modules/02-Networking/07-VirtualNetworkGateway"
  resource_group_name          = module.resource_group.name
  location                     = module.resource_group.location
  virtual_network_gateway_name = var.virtual_network_gateway_name
  virtual_network_id           = module.virtual_network.id
  subnet_id                    = module.virtual_network.gateway_subnets["gateway"]
  public_ip_address_id         = var.virtual_network_gateway_public_ip_name
  allocation_method            = var.virtual_network_gateway_public_ip_allocation_method
  gateway_type                 = var.gateway_type
  vpn_type                     = var.vpn_type
  active_active                = var.active_active
  virtual_network_gateway_sku  = var.virtual_network_gateway_sku0
  tags                         = var.tags
}
*/
#--------------------------------------------------------------------------------------------------
# 19-DNSZone
/*
module "example_dns_zone" {
  source              = "../../Modules/07-DNSZone/7.2-DNSZone"
  dns_zone_name       = var.dns_zone_name
  resource_group_name = module.resource_group.name
  tags                = var.tags
}
*/
#---------------------------------------------------------------------------------------------------
# 20-StaticWebApp
/*
module "static_web_app" {
  source              = "../../Modules/04-Web/04-StaticWebApp"
  static_webapp_name  = var.static_webapp_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  sku_tier            = var.static_webapp_sku_tier
  sku_size            = var.static_webapp_sku_size
  app_location        = var.static_webapp_location
  api_location        = var.static_webapp_api_location
  output_location     = var.static_webapp_output_location
  repository_url      = var.static_webapp_repository_url
  repository_branch   = var.static_webapp_repository_branch
  repository_token    = var.static_webapp_repository_token
  tags                = var.tags
}
*/
#---------------------------------------------------------------------------------------------------
# 21-ServiceBus
/*
module "servicebus" {
  source              = "../../Modules/13-Integration/01-ServiceBus"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  namespace_name      = var.servicebus_namespace_name
  sku                 = var.servicebus_sku
  capacity            = var.servicebus_capacity
  topic_name          = var.servicebus_topic_name
  queue_name          = var.servicebus_queue_name
  tags                = var.tags
}
*/
#---------------------------------------------------------------------------------------------------

