#-------------------------------------------------------------------------------------
# 01-ResourceGroup

resource_group_name = "myexample-stage-rg"
location            = "WEST US 3"

#-------------------------------------------------------------------------------------
# 02-VirtualNetwork

virtual_network_name = "myexample-stage-vnet"
address_space        = ["10.0.0.0/8"]

subnets = [
  {
    name           = "vm"
    address_prefix = "10.251.0.0/16"
  },
  {
    name           = "webapp"
    address_prefix = "10.252.0.0/16"
  },
  {
    name           = "db"
    address_prefix = "10.253.0.0/16"
  },
  {
    name           = "storage"
    address_prefix = "10.254.0.0/16"
  },
  {
    name           = "aks"
    address_prefix = "10.255.0.0/16"
  },
  {
    name           = "GatewaySubnet"
    address_prefix = "10.250.0.0/16"
  }
]

#-------------------------------------------------------------------------------------------------
# 03-NetworkSecurityGroup

network_security_group_name = "myexample-stage-nsg"
network_security_group_rules = [
  {
    name                       = "Allow-RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    description                = "Allow RDP from any source"
  },
  {
    name                       = "Allow-PGSQL"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5432"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    description                = "Allow PGSQL from any source"
  },
  {
    name                       = "Allow-HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    description                = "Allow HTTP from any source"
  }
]
#-----------------------------------------------------------------------------------------------
# 04-AppServicePlan

service_plan_name = "myexample-stage-asp"
asp_os_type       = "Linux"
asp_sku_name      = "B2"

#-----------------------------------------------------------------------------------------------
# 05-AppService

app_name        = "myexample-stage-webapp"
web_app_runtime = "22-lts"

#-----------------------------------------------------------------------------------------------
# 05-AppServiceContainer

linux_web_app_name       = "myexample-stage-container-webapp"
docker_image_name        = "myexamplestageacr.azurecr.io/myexample-stage:latest"
docker_image_tag         = "latest"
docker_registry_url      = "myexamplestageacr01.azurecr.io"
docker_registry_username = "myexample-stage-user"
docker_registry_password = "Passwor@1234"

#-----------------------------------------------------------------------------------------------
# 07-StorageAccount
storage_account_name               = "myexamplestagestorage"
account_tier                       = "Standard"
account_replication_type           = "LRS"
storage_account_index_document     = "index.html"
storage_account_error_404_document = "404.html"

#-----------------------------------------------------------------------------------------------
# 06-PostgreSQLDatabase

postgresql_flexible_server_name = "myexample-stage-db-pg"
postgres_sku_name               = "B_Standard_B1ms"
storage_mb                      = 32768
databases = {
  testdb = {
    charset   = "UTF8"
    collation = "en_US.utf8"
  }
}
postgre_administrator_login    = "myexampleadmin"
postgre_administrator_password = "Admin@123456"

#-----------------------------------------------------------------------------------------------  
# 08-PrivateDNSZone

private_dns_zone_name     = "myexample.co.in"
virtual_network_link_name = "myexample-stage-vnet-link"

#-----------------------------------------------------------------------------------------------
# 09-PrivateEndpoint

private_endpoint_name           = "myexample-stage-db-pg-pep"
private_dns_zone_group_name     = "myexample.co.in"
private_service_connection_name = "myexample-stage-db-pg-connection"
is_manual_connection            = false
subresource_names               = ["postgresqlServer"]

#-----------------------------------------------------------------------------------------
/*
# 10-RedisCache
cache_name                                = "myexample-stage-redis-cache"
capacity                                  = 2
family                                    = "C"
redis_cache_sku                           = "Basic"
redis_cache_public_network_access_enabled = true
redis_version                             = "6"
enable_non_ssl_port                       = false
minimum_tls_version                       = "1.2"
cluster_shard_count                       = 1
*/
#------------------------------------------------------------------------------------------
# 11-KeyVault

key_vault_name             = "myexamplestagekv"
tenant_id                  = "8fc36c8e-1077-4442-a9a3-ef873f9cc6c7"
object_id                  = "11111111-1111-1111-1111-111111111111"
key_vault_sku_name         = "standard"
soft_delete_retention_days = 7
purge_protection_enabled   = true

#-----------------------------------------------------------------------------------------------
# 12-CosmosDB

cosmosdb_account_name     = "myexample-stage-cosmosdb"
database_name             = "myexampledb"
consistency_level         = "Session"
max_interval_in_seconds   = 5
max_staleness_prefix      = 100
capabilities              = []
enable_automatic_failover = false

#-----------------------------------------------------------------------------------------------
# 13-FunctionApp

function_app_name              = "myexample-stage-funcapp"
dotnet_version                 = "dotnet6"
identity_type                  = "SystemAssigned"
run_from_package               = "1"
worker_runtime                 = "dotnet"
function_app_node_version      = "~14"
function_app_extension_version = "~4"
app_settings = {
  "MyCustomSetting" = "https://my-api.com/key"
}

#-----------------------------------------------------------------------------------------------
# 14-CommunicationService

communication_service_name      = "myexample-stage-acs"
email_service_name              = "myexample-stage-acs-email"
domain_name                     = "myexample.co.in"
enable_user_engagement_tracking = true
data_location                   = "United States"

#-----------------------------------------------------------------------------------------------  
# 15-FrontDoor

front_door_name     = "myexample-stage-afd"
front_door_sku_name = "Standard_AzureFrontDoor"

frontend_endpoint_name = "myexample-stage-frontend"
backend_endpoint_name  = "myexample-stage-backend"

frontend_origin_group_name = "frontend-stage-origin-group"
backend_origin_group_name  = "backend-stage-origin-group"

frontend_origin_name = "frontend-stage-origin"
backend_origin_name  = "backend-stage-origin"

frontend_route_name = "frontend-stage-route"
backend_route_name  = "backend-stage-route"

frontend_domain_name = "myexample-stage-frontend"
backend_domain_name  = "myexample-stage-backend"

host_frontend_domain_name = "web-stage.myexample.co.in"
host_backend_domain_name  = "api-stage.myexample.co.in"

#-----------------------------------------------------------------------------------------------
# 16-Virtual Machine  

virtual_machine_public_ip_name              = "myexample-stage-vm-ip"
virtual_machine_public_ip_allocation_method = "Static"
virtual_machine_name                        = "myexamplestagvm"
virtual_machine_size                        = "Standard_F2"
admin_username                              = "myexample"
admin_password                              = "Admin@123456"
network_interface_name                      = "myexample-stage-vm01-nic"
private_ip_address_allocation               = "Static"
private_ip_address_name                     = "myexample-stage-vm01-private-ip"
private_ip_address                          = "10.251.0.11"
os_disk_caching                             = "ReadWrite"
os_disk_storage_account_type                = "Standard_LRS"
virtual_machine_image_publisher             = "MicrosoftWindowsServer"
virtual_machine_image_offer                 = "WindowsServer"
virtual_machine_image_sku                   = "2016-datacenter"
virtual_machine_image_version               = "latest"

#-------------------------------------------------------------------------------------------------
# 17-ContainerRegistry

container_registry_name       = "myexamplestageacr"
container_registry_sku        = "Premium"
admin_enabled                 = true
public_network_access_enabled = true
quarantine_policy_enabled     = true
zone_redundancy_enabled       = true

#-------------------------------------------------------------------------------------------------
# 20-VirtualNetworkGateway
/*
virtual_network_gateway_name                        = "myexample-stage-vnet-gateway01"
virtual_network_gateway_public_ip_name              = "myexample-stage-vnet-gateway-ip"
gateway_type                                        = "Vpn"
vpn_type                                            = "RouteBased"
active_active                                       = false
virtual_network_gateway_sku                         = "VpnGw1"
virtual_network_gateway_public_ip_allocation_method = "Static"
*/
#------------------------------------------------------------------------------------------------
# 19-DNSZone

dns_zone_name = "myexample.co.in"

#------------------------------------------------------------------------------------------------


