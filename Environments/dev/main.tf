#---------------------------------------------------------------------------------------------------
# 00-Provider

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = "c09e0f60-cb15-4c23-8500-eeae1ec9dd6b"
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
  source               = "../../Modules/02-VirtualNetwork"
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
  source                       = "../../Modules/03-NetworkSecurityGroup"
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
  source              = "../../Modules/04-AppServicePlan"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  service_plan_name   = var.service_plan_name
  asp_os_type         = var.asp_os_type
  asp_sku_name        = var.asp_sku_name
  tags                = local.tags
}

#---------------------------------------------------------------------------------------------------
# 05-AppServiceContainer

module "azurerm_app_service_container" {
  source                   = "../../Modules/05-AppServiceContainer"
  resource_group_name      = module.resource_group.name
  location                 = module.resource_group.location
  linux_web_app_name       = var.linux_web_app_name
  service_plan_id          = module.service_plan.id
  docker_image_name        = var.docker_image_name
  docker_image_tag         = var.docker_image_tag
  docker_registry_url      = var.docker_registry_url
  docker_registry_username = var.docker_registry_username
  docker_registry_password = var.docker_registry_password
  tags                     = local.tags
}
#--------------------------------------------------------------------------------------------------
# 06-AppService

module "azurerm_app_service" {
  source = "../../Modules/05-AppService"

  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  service_plan_id     = module.service_plan.id
  app_name            = var.app_name
  runtime             = var.runtime

  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION"   = var.app_service_node_version
    "APPINSIGHTS_INSTRUMENTATIONKEY" = "some-key"
  }
}

#--------------------------------------------------------------------------------------------------
# 06-StorageAccount

module "storage_account" {
  source                             = "../../Modules/06-StorageAccount"
  resource_group_name                = module.resource_group.name
  location                           = module.resource_group.location
  storage_account_name               = var.storage_account_name
  account_tier                       = var.account_tier
  account_replication_type           = var.account_replication_type
  storage_account_index_document     = var.storage_account_index_document
  storage_account_error_404_document = var.storage_account_error_404_document
  tags                               = local.tags
}

#--------------------------------------------------------------------------------------------------
# 07-PostgresSQLFlexible

module "postgre_sql" {
  source                          = "../../Modules/07-PostgresSQLFlexible"
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

#--------------------------------------------------------------------------------------------------
# 08-PrivateEndPoint (PostgresSQLFelxible) 

module "private_endpoint_postgres" {
  source                          = "../../Modules/08-PrivateEndPoint"
  private_endpoint_name           = var.private_endpoint_name
  private_dns_zone_ids            = [module.private_dns_zone.private_dns_zone_id]
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

#--------------------------------------------------------------------------------------------------
# 09-PrivateDNSZone

module "private_dns_zone" {
  source                    = "../../Modules/09-PrivateDNSZone"
  private_dns_zone_name     = var.private_dns_zone_group_name
  resource_group_name       = module.resource_group.name
  location                  = module.resource_group.location
  virtual_network_link_name = var.virtual_network_link_name
  virtual_network_id        = module.virtual_network.id
  tags                      = local.tags
}
#--------------------------------------------------------------------------------------------
# 11-KeyVault

module "keyvault" {
  source              = "../../Modules/11-KeyVault"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  key_vault_name      = var.key_vault_name
  tenant_id           = var.tenant_id
  object_id           = var.object_id
  tags                = local.tags
}

#--------------------------------------------------------------------------------------------------
# 10-CacheRedis

module "redis" {
  source                        = "../../Modules/10-CacheRedis"
  cache_name                    = var.cache_name
  location                      = module.resource_group.location
  resource_group_name           = module.resource_group.name
  capacity                      = var.capacity
  family                        = var.family
  sku                           = var.sku
  public_network_access_enabled = var.public_network_access_enabled
  redis_version                 = var.redis_version
  enable_non_ssl_port           = var.enable_non_ssl_port
  minimum_tls_version           = var.minimum_tls_version
  cluster_shard_count           = var.cluster_shard_count
  tags                          = local.tags
}
#---------------------------------------------------------------------------------------------
# 12 - CosmosDB

module "cosmosdb" {
  source                    = "../../Modules/12-CosmosDB" # relative path to child module
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
#--------------------------------------------------------------------------------------------------
# 13-FunctionsApp

module "function_app" {
  source              = "../../Modules/13-Functionsapp"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location

  storage_account_name       = module.storage_account.name
  storage_account_access_key = module.storage_account.access_key

  app_service_plan_name = module.service_plan.id
  function_app_name     = var.function_app_name

  dotnet_version            = var.dotnet_version
  identity_type             = var.identity_type
  run_from_package          = var.run_from_package
  worker_runtime            = var.worker_runtime
  function_app_node_version = var.function_app_node_version
  app_settings              = var.app_settings
  tags                      = var.tags
}

#--------------------------------------------------------------------------------------------------
# 14-CommunicationsService

module "communication_services" {
  source                          = "../../Modules/14-CommunicationServices"
  communication_service_name      = var.communication_service_name
  email_service_name              = var.email_service_name
  domain_name                     = var.domain_name
  enable_user_engagement_tracking = var.enable_user_engagement_tracking
  resource_group_name             = module.resource_group.name
  data_location                   = var.data_location
  tags                            = local.tags
}

#--------------------------------------------------------------------------------------------------
# 15-FrontDoorStandard

module "azure_front_door" {
  source              = "../../Modules/15-FrontDoor"
  front_door_name     = var.front_door_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  front_door_sku_name = var.front_door_sku_name

  frontend_endpoint_name = var.frontend_endpoint_name
  backend_endpoint_name  = var.backend_endpoint_name

  frontend_origin_group_name = var.frontend_origin_group_name
  backend_origin_group_name  = var.backend_origin_group_name

  frontend_origin_name = var.frontend_origin_name
  backend_origin_name  = var.backend_origin_name

  frontend_route_name = var.frontend_route_name
  backend_route_name  = var.backend_route_name

  frontend_domain_name = var.frontend_domain_name
  backend_domain_name  = var.backend_domain_name

  host_frontend_domain_name = var.host_frontend_domain_name
  host_backend_domain_name  = var.host_backend_domain_name

  tags = local.tags
}

#--------------------------------------------------------------------------------------------------------------
# 16-Virtual Machine

module "virtual_machine" {
  source                          = "../../Modules/16-VirtualMachine"
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

#--------------------------------------------------------------------------------------------------
# 17-ContainerRegistry

module "azurerm_container_registry" {
  source                        = "../../Modules/17-ContainerRegistry"
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

#--------------------------------------------------------------------------------------------------


