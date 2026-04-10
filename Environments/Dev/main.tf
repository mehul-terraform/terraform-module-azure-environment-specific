#--------------------------------------------------------------------------------------------------
# 01-ResourceGroup
#--------------------------------------------------------------------------------------------------

module "resource_group" {
  source          = "../../Modules/01-ResourceGroup"
  resource_groups = var.resource_groups
  tags            = local.tags
}

#--------------------------------------------------------------------------------------------------
# 02-Networking
#--------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------
# 02.01-VirtualNetwork
#--------------------------------------------------------------------------------------------------

module "virtual_network" {
  source              = "../../Modules/02-Networking/01-VirtualNetwork"
  resource_group_name = module.resource_group.names["main"]
  location            = module.resource_group.locations["main"]
  virtual_networks    = var.virtual_networks
  tags                = local.tags
}

#--------------------------------------------------------------------------------------------------
# 02.02-NetworkSecurityGroup
#--------------------------------------------------------------------------------------------------

# module "network_security_group" {
#   source                  = "../../Modules/02-Networking/02-NetworkSecurityGroup"
#   resource_group_name     = module.resource_group.names["main"]
#   location                = module.resource_group.locations["main"]
#   network_security_groups = var.network_security_groups
#   vnet_subnet_ids         = module.virtual_network.subnet_ids
#   tags                    = local.tags
#   depends_on              = [module.virtual_network]
# }

#--------------------------------------------------------------------------------------------------
# 02.03-VirtualNetworkGateway
#--------------------------------------------------------------------------------------------------

# module "virtual_network_gateway" {
#   source                   = "../../Modules/02-Networking/03-VirtualNetworkGateway"
#   resource_group_name      = module.resource_group.names["main"]
#   location                 = module.resource_group.locations["main"]
#   virtual_network_gateways = var.virtual_network_gateways

#   subnet_id = module.virtual_network.subnet_ids["main-GatewaySubnet"]
#   tags      = var.tags
# }


#--------------------------------------------------------------------------------------------------
# 03-Compute
#--------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------
# 03.01-VirtualMachineLinux
#--------------------------------------------------------------------------------------------------

# module "virtual_machine_linux" {
#   source              = "../../Modules/03-Compute/01-VirtualMachineLinux"
#   resource_group_name = module.resource_group.names["main"]
#   location            = module.resource_group.locations["main"]
#   subnet_id           = module.virtual_network.subnet_ids["main-vm"]
#   virtual_machines    = var.virtual_machines_linux
#   key_vault_id        = module.keyvault.ids["main-backend"]
#   tags                = local.tags

#   depends_on = [module.keyvault.terraform_kv_secrets_officer_role_assignment_ids]
# }

#--------------------------------------------------------------------------------------------------
# 03.02-VirtualMachineWindows
#--------------------------------------------------------------------------------------------------

# module "virtual_machine_windows" {
#   source              = "../../Modules/03-Compute/02-VirtualMachineWindows"
#   resource_group_name = module.resource_group.names["main"]
#   location            = module.resource_group.locations["main"]
#   subnet_id           = module.virtual_network.subnet_ids["main-vm"]
#   virtual_machines    = var.virtual_machines_windows
#   key_vault_id        = module.keyvault.ids["main-backend"]
#   tags                = local.tags

#   depends_on = [module.keyvault.terraform_kv_secrets_officer_role_assignment_ids]
# }

#--------------------------------------------------------------------------------------------------
# 03.03-ContainerRegistry
#--------------------------------------------------------------------------------------------------

# module "container_registry" {
#   source               = "../../Modules/03-Compute/03-ContainerRegistry"
#   resource_group_name  = module.resource_group.names["main"]
#   location             = module.resource_group.locations["main"]
#   container_registries = var.container_registries
#   tags                 = local.tags
# }

#--------------------------------------------------------------------------------------------------
# 03.04-AKS
#--------------------------------------------------------------------------------------------------

# module "aks" {
#   source              = "../../Modules/03-Compute/04-AKS"
#   aks_clusters        = var.aks_clusters
#   subnet_id           = module.virtual_network.subnet_ids["main-aks"]
#   resource_group_name = module.resource_group.names["main"]
#   location            = module.resource_group.locations["main"]
#   tags                = local.tags
# }

#--------------------------------------------------------------------------------------------------
# 03.05-ContainerApps
#--------------------------------------------------------------------------------------------------

# module "container_apps" {
#   source                     = "../../Modules/03-Compute/05-ContainerApps"
#   container_app_environments = var.container_app_environments
#   container_apps             = var.container_apps
#   log_analytics_workspace_id = module.log_analytics.ids["main"]
#   resource_group_name        = module.resource_group.names["main"]
#   location                   = module.resource_group.locations["main"]
#   tags                       = local.tags
# }

#--------------------------------------------------------------------------------------------------
# 04-Web
#--------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------
# 04.01-AppServicePlan
#--------------------------------------------------------------------------------------------------

# module "app_service_plan" {
#   source        = "../../Modules/04-Web/01-AppServicePlan"
#   service_plans = var.service_plans

#   location            = module.resource_group.locations["main"]
#   resource_group_name = module.resource_group.names["main"]
#   tags                = var.tags
# }

#--------------------------------------------------------------------------------------------------
# 04.02-AppServiceLinux
#--------------------------------------------------------------------------------------------------

# module "app_service_linux" {
#   source = "../../Modules/04-Web/02-AppServiceLinux"

#   app_service         = var.app_service_linux
#   resource_group_name = module.resource_group.names["main"]
#   location            = module.resource_group.locations["main"]
#   service_plan_ids    = module.app_service_plan.ids
#   subnet_id           = module.virtual_network.subnet_ids["main-webapp"]
#   managed_identity_id = module.managed_identity.ids["main"]
#   tags                = local.tags
# }

#--------------------------------------------------------------------------------------------------
# 04.03-AppServiceWindows
#--------------------------------------------------------------------------------------------------

# module "app_service_windows" {
#   source              = "../../Modules/04-Web/03-AppServiceWindows"
#   app_service_windows = var.app_service_windows

#   location            = module.resource_group.locations["main"]
#   resource_group_name = module.resource_group.names["main"]
#   service_plan_ids    = module.app_service_plan.ids
#   subnet_id           = module.virtual_network.subnet_ids["main-webapp"]
#   managed_identity_id = module.managed_identity.ids["main"]
#   tags                = local.tags
# }

#--------------------------------------------------------------------------------------------------
# 04.04-AppServiceContainerLinux
#--------------------------------------------------------------------------------------------------

# module "app_service_container_linux" {
#   source = "../../Modules/04-Web/04-AppServiceContainerLinux"

#   app_service_container = var.app_service_container_linux
#   resource_group_name   = module.resource_group.names["main"]
#   location              = module.resource_group.locations["main"]
#   service_plan_ids      = module.app_service_plan.ids
#   subnet_id             = module.virtual_network.subnet_ids["main-webapp"]
#   managed_identity_id   = module.managed_identity.ids["main"]
#   tags                  = local.tags
# }

#--------------------------------------------------------------------------------------------------
# 04.05-AppServiceContainerWindows
#--------------------------------------------------------------------------------------------------

# module "app_service_container_windows" {
#   source = "../../Modules/04-Web/05-AppServiceContainerWindows"

#   app_service_container_windows = var.app_service_container_windows
#   resource_group_name           = module.resource_group.names["main"]
#   location                      = module.resource_group.locations["main"]
#   service_plan_ids              = module.app_service_plan.ids
#   subnet_id                     = module.virtual_network.subnet_ids["main-webapp"]
#   managed_identity_id           = module.managed_identity.ids["main"]
#   tags                          = local.tags
# }

#--------------------------------------------------------------------------------------------------
# 04.06-FunctionsAppLinux
#--------------------------------------------------------------------------------------------------

# module "function_app_linux" {
#   source              = "../../Modules/04-Web/06-FunctionsAppLinux"
#   resource_group_name = module.resource_group.names["main"]
#   location            = module.resource_group.locations["main"]
#   function_apps       = var.function_app_linux
#   subnet_id           = module.virtual_network.subnet_ids["main-funcapp"]
#   managed_identity_id = module.managed_identity.ids["main"]
#   tags                = local.tags
# }

#--------------------------------------------------------------------------------------------------
# 04.07-FunctionsAppWindows
#--------------------------------------------------------------------------------------------------

# module "function_app_windows" {
#   source              = "../../Modules/04-Web/07-FunctionsAppWindows"
#   resource_group_name = module.resource_group.names["main"]
#   location            = module.resource_group.locations["main"]
#   function_apps       = var.function_app_windows
#   subnet_id           = module.virtual_network.subnet_ids["main-funcapp"]
#   managed_identity_id = module.managed_identity.ids["main"]
#   tags                = local.tags
# }

#--------------------------------------------------------------------------------------------------
# 04.08-FunctionsAppFlexConsumption
#--------------------------------------------------------------------------------------------------

# module "function_app_flex" {
#   source              = "../../Modules/04-Web/08-FunctionsAppFlexConsumption"
#   resource_group_name = module.resource_group.names["main"]
#   location            = module.resource_group.locations["main"]
#   function_apps       = var.function_app_flex
#   subnet_id           = module.virtual_network.subnet_ids["main-funcapp"]
#   managed_identity_id = module.managed_identity.ids["main"]
#   tags                = var.tags
# }

#--------------------------------------------------------------------------------------------------
# 04.09-StaticWebApp
#--------------------------------------------------------------------------------------------------

# module "static_web_app" {
#   source              = "../../Modules/04-Web/09-StaticWebApp"
#   resource_group_name = module.resource_group.names["main"]
#   static_web_apps     = var.static_web_app
#   tags                = var.tags
# }

#--------------------------------------------------------------------------------------------------
# 05-StorageAccount
#--------------------------------------------------------------------------------------------------

# module "storage_account" {
#   source           = "../../Modules/05-StorageAccount"
#   storage_accounts = var.storage_accounts

#   location            = module.resource_group.locations["main"]
#   resource_group_name = module.resource_group.names["main"]

#   tags = var.tags
# }

#--------------------------------------------------------------------------------------------------
# 06-Database
#--------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------
# 06.01-PostgresSQLFlexible
#--------------------------------------------------------------------------------------------------

# module "postgres_sql_flexible" {
#   source = "../../Modules/06-Database/01-PostgreSQLFlexible"

#   postgre_sql         = var.postgres_sql
#   location            = module.resource_group.locations["main"]
#   resource_group_name = module.resource_group.names["main"]

#   delegated_subnet_id = null
#   private_dns_zone_id = null
#   key_vault_id        = module.keyvault.ids["main-backend"]

#   depends_on = [
#     module.keyvault.terraform_kv_secrets_officer_role_assignment_ids
#   ]

#   tags = var.tags
# }

#--------------------------------------------------------------------------------------------------
# 06.02-CosmosDB
#--------------------------------------------------------------------------------------------------

# module "cosmosdb" {
#   source              = "../../Modules/06-Database/02-CosmosDB"
#   resource_group_name = module.resource_group.names["main"]
#   location            = module.resource_group.locations["main"]
#   cosmos_dbs          = var.cosmos_dbs
#   subnet_id           = module.virtual_network.subnet_ids["main-private-endpoint"]
#   tags                = local.tags
# }

#--------------------------------------------------------------------------------------------------
# 06.03-ManagedRedis
#--------------------------------------------------------------------------------------------------

# module "managed_redis" {
#   source                  = "../../Modules/06-Database/03-ManagedRedis"
#   resource_group_name     = module.resource_group.names["main"]
#   location                = module.resource_group.locations["main"]
#   managed_redis_instances = var.managed_redis_instances
#   tags                    = local.tags
# }

#--------------------------------------------------------------------------------------------------
# 07-DNSZone
#--------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------
# 07.01-PrivateDNSZone
#--------------------------------------------------------------------------------------------------

# module "private_dns_zones" {
#   source = "../../Modules/07-DNSZone/7.1-PrivateDNSZone"

#   resource_group_name = module.resource_group.names["main"]
#   virtual_network_id  = module.virtual_network.ids["main"]
#   tags                = local.tags

#   private_dns_zones = var.private_dns_zones
#   depends_on        = [module.resource_group]
# }

#--------------------------------------------------------------------------------------------------
# 07.02-DNSZone
#--------------------------------------------------------------------------------------------------

# module "example_dns_zone" {
#   source              = "../../Modules/07-DNSZone/7.2-DNSZone"
#   resource_group_name = module.resource_group.names["main"]

#   dns_zones = {
#     for zone_key, zone in var.dns_zones : zone_key => (
#       contains(["myexample-in", "myexample-us"], zone_key) ? merge(zone, {
#         cname_records = merge(try(zone.cname_records, {}), {
#           # Main (tst)
#           "api-tst" = module.azure_front_door.backend_endpoint["main"]
#           "tst"     = module.azure_front_door.frontend_endpoint["main"]
#           # Dev
#           "api-dev" = module.azure_front_door.backend_endpoint["dev"]
#           "dev"     = module.azure_front_door.frontend_endpoint["dev"]
#         })
#         txt_records = merge(try(zone.txt_records, {}), {
#           # Main (tst)
#           "_dnsauth.tst"     = module.azure_front_door.frontdoor_frontend_validation_token["main"]
#           "_dnsauth.api-tst" = module.azure_front_door.frontdoor_backend_validation_token["main"]
#           # Dev
#           "_dnsauth.dev"     = module.azure_front_door.frontdoor_frontend_validation_token["dev"]
#           "_dnsauth.api-dev" = module.azure_front_door.frontdoor_backend_validation_token["dev"]
#         })
#       }) : zone
#     )
#   }

#   depends_on = [
#     module.azure_front_door
#   ]

#   tags = local.tags
# }

#--------------------------------------------------------------------------------------------------
# 08-PrivateEndPoints
#--------------------------------------------------------------------------------------------------

# module "private_endpoints" {
#   source = "../../Modules/08-PrivateEndPoints"

#   private_endpoints = {
#     for k, v in var.private_endpoints : k => {
#       name                = v.name
#       location            = module.resource_group.locations["main"]
#       resource_group_name = module.resource_group.names["main"]
#       subresource_names   = v.subresource_names
#       tags                = v.tags

#       # Use NON-delegated PE subnet
#       subnet_id = module.virtual_network.subnet_ids["main-private-endpoint"]

#       resource_id = (
#         v.service == "storage" ? module.storage_account.storage_account_ids[v.instance] :

#         v.service == "webapp-linux" ? module.app_service_linux.app_service_ids[v.instance] :
#         v.service == "webapp-windows" ? module.app_service_windows.app_service_ids[v.instance] :

#         v.service == "functionapp-linux" ? module.function_app_linux.ids[v.instance] :
#         v.service == "functionapp-windows" ? module.function_app_windows.ids[v.instance] :

#         v.service == "webapp-container-linux" ? module.app_service_container_linux.app_service_ids[v.instance] :
#         v.service == "webapp-container-windows" ? module.app_service_container_windows.app_service_ids[v.instance] :

#         v.service == "functionapp-flex" ? module.function_app_flex.function_app_ids[v.instance] :

#         v.service == "postgres" ? module.postgres_sql_flexible.ids[v.instance] :

#         v.service == "cosmosdb" ? module.cosmosdb.cosmosdb_account_ids[v.instance] :

#         v.service == "keyvault" ? module.keyvault.ids[v.instance] :
#         null
#       )

#       private_dns_zone_ids = [
#         v.service == "storage" ? module.private_dns_zones.private_dns_zone_ids["blob"] :
#         v.service == "webapp-linux" ? module.private_dns_zones.private_dns_zone_ids["sites"] :
#         v.service == "webapp-windows" ? module.private_dns_zones.private_dns_zone_ids["sites"] :
#         v.service == "webapp-container-linux" ? module.private_dns_zones.private_dns_zone_ids["sites"] :
#         v.service == "webapp-container-windows" ? module.private_dns_zones.private_dns_zone_ids["sites"] :
#         v.service == "functionapp-linux" ? module.private_dns_zones.private_dns_zone_ids["sites"] :
#         v.service == "functionapp-windows" ? module.private_dns_zones.private_dns_zone_ids["sites"] :
#         v.service == "functionapp-flex" ? module.private_dns_zones.private_dns_zone_ids["sites"] :
#         v.service == "postgres" ? module.private_dns_zones.private_dns_zone_ids["postgres"] :
#         v.service == "cosmosdb" ? module.private_dns_zones.private_dns_zone_ids["cosmosdb"] :
#         v.service == "keyvault" ? module.private_dns_zones.private_dns_zone_ids["keyvault"] :
#         null
#       ]
#     }
#   }
# }

#--------------------------------------------------------------------------------------------------
# 09-CacheRedis
#--------------------------------------------------------------------------------------------------

# module "cache_redis" {
#   source               = "../../Modules/09-CacheRedis"
#   redis_caches         = var.redis_caches
#   redis_firewall_rules = var.redis_firewall_rules
#   resource_group_name  = module.resource_group.names["main"]
#   location             = module.resource_group.locations["main"]
#   tags                 = local.tags
# }

#--------------------------------------------------------------------------------------------------
# 10-KeyVault
#--------------------------------------------------------------------------------------------------

# module "keyvault" {
#   source                 = "../../Modules/10-KeyVault"
#   key_vaults             = var.key_vaults
#   resource_group_name    = module.resource_group.names["main"]
#   location               = module.resource_group.locations["main"]
#   tenant_id              = data.azurerm_client_config.current.tenant_id
#   current_user_object_id = data.azurerm_client_config.current.object_id
#   tags                   = local.tags
# }


#--------------------------------------------------------------------------------------------------
# 11-CommunicationServices
#--------------------------------------------------------------------------------------------------

# module "communication_services" {
#   source                 = "../../Modules/11-CommunicationServices"
#   communication_services = var.communication_services
#   resource_group_name    = module.resource_group.names["main"]
#   tags                   = local.tags
# }

#--------------------------------------------------------------------------------------------------
# 12-NotificationsHub
#--------------------------------------------------------------------------------------------------

# module "notification_hub" {
#   source                      = "../../Modules/12-NotificationsHub"
#   resource_group_name         = module.resource_group.names["main"]
#   location                    = module.resource_group.locations["main"]
#   notification_hub_namespaces = var.notification_hub_namespaces
#   tags                        = var.tags
# }

#--------------------------------------------------------------------------------------------------
# 13-Integration
#--------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------
# 13.01-ServiceBus
#--------------------------------------------------------------------------------------------------

# module "servicebus" {
#   source              = "../../Modules/13-Integration/01-ServiceBus"
#   resource_group_name = module.resource_group.names["main"]
#   location            = module.resource_group.locations["main"]
#   service_buses       = var.service_buses
#   tags                = var.tags
# }

#--------------------------------------------------------------------------------------------------
# 13.02-EventHub
#--------------------------------------------------------------------------------------------------

# module "eventhub" {
#   source              = "../../Modules/13-Integration/02-EventHub"
#   resource_group_name = module.resource_group.names["main"]
#   location            = module.resource_group.locations["main"]
#   eventhub_namespaces = var.eventhub_namespaces
#   tags                = var.tags
# }

#--------------------------------------------------------------------------------------------------
# 13.03-EventGrid (commented)
#--------------------------------------------------------------------------------------------------

# module "eventgrid" {
#   source = "../../Modules/13-Integration/03-EventGrid"

#   resource_group_name     = module.resource_group.names["main"]
#   location                = module.resource_group.locations["main"]
#   eventgrid_topics        = var.eventgrid_topics
#   eventgrid_subscriptions = var.eventgrid_subscriptions
# }

#--------------------------------------------------------------------------------------------------
# 14.01-Monitor-Log Analytics workspaces
#--------------------------------------------------------------------------------------------------

# module "log_analytics" {
#   source              = "../../Modules/14-Monitor/02-LogAnalyticsWorkspaces"
#   resource_group_name = module.resource_group.names["main"]
#   location            = module.resource_group.locations["main"]
#   workspaces          = var.log_analytics_workspaces
#   tags                = local.tags
# }

#--------------------------------------------------------------------------------------------------
# 15-LoadBalancer
#--------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------
# 15.01-FrontDoorWafPolicy
#--------------------------------------------------------------------------------------------------

# module "waf_policy" {
#   source              = "../../Modules/15-LoadBalancer/05-FrontDoorWafPolicy"
#   resource_group_name = module.resource_group.names["main"]
#   waf_policies        = var.waf_policies
#   tags                = local.tags
# }

# locals {
#   all_web_hostnames = merge(
#     module.static_web_app.static_site_urls,
#     module.app_service_container_linux.default_hostnames
#   )
# }

#--------------------------------------------------------------------------------------------------
# 15.02-FrontDoor
#--------------------------------------------------------------------------------------------------

# module "azure_front_door" {
#   source = "../../Modules/15-LoadBalancer/01-FrontDoor"
#   front_doors = {
#     for k, v in var.front_doors : k => merge(v, {
#       waf_policy_link_id = try(module.waf_policy.ids[k], null)

#       # Dynamic Hostnames: Totally Dynamic Resolution from local.all_web_hostnames
#       origin_host_frontend_name = coalesce(
#         try(local.all_web_hostnames[v.origin_frontend_key], null),
#         try(local.all_web_hostnames[v.origin_frontend_static_key], null),
#         try(local.all_web_hostnames[v.origin_frontend_webapp_key], null),
#         v.origin_host_frontend_name
#       )
#       origin_host_backend_name = coalesce(
#         try(local.all_web_hostnames[v.origin_backend_key], null),
#         try(local.all_web_hostnames[v.origin_backend_webapp_key], null),
#         v.origin_host_backend_name
#       )
#     })
#   }

#   resource_group_name = module.resource_group.names["main"]
#   location            = module.resource_group.locations["main"]
#   tags                = local.tags

#   depends_on = [
#     module.waf_policy,
#     module.app_service_container_linux,
#     module.static_web_app
#   ]
# }

#--------------------------------------------------------------------------------------------------
# 16-AppConfiguration
#--------------------------------------------------------------------------------------------------

# module "app_configurations" {
#   source = "../../Modules/16-AppConfiguration"

#   resource_group_name = module.resource_group.names["main"]
#   location            = module.resource_group.locations["main"]
#   app_configurations  = var.app_configurations
#   tags                = var.tags
# }

#--------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------
# 17-ManagedIdentity
#--------------------------------------------------------------------------------------------------

# module "managed_identity" {
#   source              = "../../Modules/17-ManagedIdentity"
#   managed_identities  = var.managed_identities
#   location            = module.resource_group.locations["main"]
#   resource_group_name = module.resource_group.names["main"]
#   tags                = local.tags
# }

# resource "azurerm_role_assignment" "keyvault_access" {
#   scope                = module.keyvault.ids["main-backend"]
#   role_definition_name = "Key Vault Secrets User"
#   principal_id         = module.managed_identity.principal_ids["main"]
# }

#--------------------------------------------------------------------------------------------------
# 19-AI
#--------------------------------------------------------------------------------------------------

# module "openai" {
#   source              = "../../Modules/19-AI/01-AzureOpenAI"
#   openai_accounts     = var.openai_accounts
#   openai_deployments  = var.openai_deployments
#   resource_group_name = module.resource_group.names["main"]
#   location            = module.resource_group.locations["main"]
#   tags                = local.tags
# }

#-------------------------------------------------------------------------------------------
