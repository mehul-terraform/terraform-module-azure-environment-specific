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
  webapp_subnet_id             = module.virtual_network.webapp_subnets["webapp"]
  tags                         = local.tags
}

#--------------------------------------------------------------------------------------------------
# 04.01-AppServicePlan

module "app_service_plan" {
  source        = "../../Modules/04-Web/01-AppServicePlan"
  service_plans = var.service_plans

  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  tags                = var.tags
}

#--------------------------------------------------------------------------------------------------
# 04.02-AppService

module "app_service" {
  source = "../../Modules/04-Web/02-AppServiceLinux"

  app_service         = var.app_service
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  service_plan_id     = module.app_service_plan.ids["linux"]
  subnet_id           = module.virtual_network.webapp_subnets["webapp"]
  tags                = local.tags
}

#---------------------------------------------------------------------------------------------------
#04.03-AppServiceWindows

module "windows_web_app" {
  source = "../../Modules/04-Web/03-AppServiceWindows"
  app_service_windows = var.app_service_windows

  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  service_plan_id     = module.app_service_plan.ids["windows"]
  subnet_id           = module.virtual_network.webapp_subnets["webapp"]
  tags                = local.tags
}

#---------------------------------------------------------------------------------------------------
# 04.03-AppServiceContainer

module "app_service_container" {
  source = "../../Modules/04-Web/03-AppServiceContainer"

  app_service_container = var.app_service_container
  resource_group_name   = module.resource_group.name
  location              = module.resource_group.location
  service_plan_id       = module.app_service_plan.ids["linux"]
  subnet_id             = module.virtual_network.webapp_subnets["webapp"]
  tags                  = local.tags
}

#--------------------------------------------------------------------------------------------------
# 05.02-StorageAccount

module "storage_account" {
  source           = "../../Modules/05-StorageAccount"
  storage_accounts = var.storage_accounts

  location            = module.resource_group.location
  resource_group_name = module.resource_group.name

  tags = var.tags
}

#--------------------------------------------------------------------------------------------------
# 06.01-PostgresSQLFlexible

module "postgres_sql_flexible" {
  source = "../../Modules/06-Database/01-PostgreSQLFlexible"

  postgre_sql = var.postgre_sql
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name

  delegated_subnet_id = null
  private_dns_zone_id = null
  key_vault_id        = module.keyvault.id

  #password_rotation_version = var.password_rotation_versioncd e
  
  tags = var.tags
}

#--------------------------------------------------------------------------------------------------
module "private_dns_zones" {
  source = "../../Modules/07-DNSZone/7.1-PrivateDNSZone"

  resource_group_name = var.resource_group_name
  virtual_network_id  = module.virtual_network.id
  tags                = local.tags

  private_dns_zones = var.private_dns_zones
  depends_on        = [module.resource_group.id]

}

#---------------------------------------------------------------------------------------------
# PrivateEndpoints

module "private_endpoints" {
  source = "../../Modules/08-PrivateEndPoints"

  private_endpoints = {
    for k, v in var.private_endpoints : k => {
      name                = v.name
      location            = var.location
      resource_group_name = var.resource_group_name
      subresource_names   = v.subresource_names
      tags                = v.tags

      # Use NON-delegated PE subnet
      subnet_id = module.virtual_network.private_endpoint_subnets["private_endpoint"]

      resource_id = (
        v.service == "postgres" ? module.postgres_sql_flexible.ids[v.instance] :
        v.service == "storage" ? module.storage_account.storage_account_ids[v.instance] :
        v.service == "webapp" ? module.app_service.app_service_ids[v.instance] :
        v.service == "webapp-container" ? module.app_service_container.app_service_ids[v.instance] :
        v.service == "keyvault" ? module.keyvault.id :
        null
      )

      private_dns_zone_ids = [
        v.service == "postgres" ? module.private_dns_zones.private_dns_zone_ids["postgres"] :
        v.service == "storage" ? module.private_dns_zones.private_dns_zone_ids["blob"] :
        v.service == "webapp" ? module.private_dns_zones.private_dns_zone_ids["webapp"] :
        v.service == "webapp-container" ? module.private_dns_zones.private_dns_zone_ids["webapp"] :
        v.service == "keyvault" ? module.private_dns_zones.private_dns_zone_ids["keyvault"] :
        null
      ]
    }
  }
}

#--------------------------------------------------------------------------------------------------
# 09-CacheRedis
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
# 10-KeyVault

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

#---------------------------------------------------------------------------------------------
# 6.2-CosmosDB
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
# 05-FunctionsApp
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
  app_settings                   = var.function_app_settings
  tags                           = var.tags
}
*/

#--------------------------------------------------------------------------------------------------
# 06-FunctionsAppFlexConsumption

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
  subnet_id             = module.virtual_network.webapp_subnets["webapp"]

  identity_type = var.function_app_flex_identity_type
  app_settings  = var.function_app_flex_app_settings
  tags          = var.tags
}

#--------------------------------------------------------------------------------------------------
# 11-CommunicationsService
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
# 15.1-FrontDoorStandard
/*
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

  #origin_host_frontend_name = replace(
  #  replace(module.storage_account_website.static_website_url, "https://", ""),
  #  "/", ""
  #)
  origin_host_frontend_name = module.static_web_app.static_site_url
  #origin_host_frontend_name = module.app_service_container.default_hostnames["frontend"]
  origin_host_backend_name = module.app_service_container.default_hostnames["backend"]

  custome_domain_frontend_name = var.custome_domain_frontend_name
  custome_domain_backend_name  = var.custome_domain_backend_name

  host_custome_domain_frontend_name = var.host_custome_domain_frontend_name
  host_custome_domain_backend_name  = var.host_custome_domain_backend_name

  route_frontend_name = var.route_frontend_name
  route_backend_name  = var.route_backend_name

  tags = local.tags
}
*/
#--------------------------------------------------------------------------------------------------------------
# 3.1-VirtualMachine

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

#--------------------------------------------------------------------------------------------------
# 3.2-ContainerRegistry
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
# 3.3-VirtualNetworkGateway
/*
module "virtual_network_gateway" {
  source                       = "../../Modules/02-Networking/03-VirtualNetworkGateway"
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
  virtual_network_gateway_sku  = var.virtual_network_gateway_sku
  tags                         = var.tags
}
*/
#--------------------------------------------------------------------------------------------------
# 7.2-DNSZone
/*
module "example_dns_zone" {
  source              = "../../Modules/07-DNSZone/7.2-DNSZone"
  dns_zone_name       = var.dns_zone_name
  resource_group_name = module.resource_group.name

  cname_records = {
    api-dev = module.azure_front_door.backend_endpoint
    dev     = module.azure_front_door.frontend_endpoint
  }

  txt_records = {
    "_dnsauth.dev" = module.azure_front_door.frontdoor_frontend_validation_token
    "_dnsauth.api-dev"  = module.azure_front_door.frontdoor_backend_validation_token
  }

  depends_on = [
    module.azure_front_door
  ]

  tags = local.tags
}
*/
#---------------------------------------------------------------------------------------------------
# 04-StaticWebApp
/*
module "static_web_app" {
  source                 = "../../Modules/04-Web/04-StaticWebApp"
  static_webapp_name     = var.static_webapp_name
  resource_group_name    = module.resource_group.name
  static_webapp_location = var.static_webapp_location
  sku_tier               = var.static_webapp_sku_tier
  sku_size               = var.static_webapp_sku_size
  app_location           = var.static_webapp_location
  api_location           = var.static_webapp_api_location
  output_location        = var.static_webapp_output_location
  repository_url         = var.static_webapp_repository_url
  repository_branch      = var.static_webapp_repository_branch
  repository_token       = var.static_webapp_repository_token
  tags                   = var.tags
}
*/
#---------------------------------------------------------------------------------------------------
# 13.1-ServiceBus
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
# 16-AppCOnfiguration
/*
module "app_configurations" {
  source   = "../../Modules/16-AppConfiguration"
  for_each = var.app_configurations

  name                = each.value.name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  tags                = var.tags

  key_values = lookup(each.value, "key_values", {})
}
*/
#--------------------------------------------------------------------------------------------------

