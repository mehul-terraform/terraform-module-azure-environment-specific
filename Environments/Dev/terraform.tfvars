#------------------------------------------------------------------------------------
# Project Details
#------------------------------------------------------------------------------------
project     = "myexample"
environment = "dev"

#-------------------------------------------------------------------------------------
# 01-ResourceGroup
#-------------------------------------------------------------------------------------

resource_group_name = "myexample-dev-rg"
location            = "WEST US 3"

#-------------------------------------------------------------------------------------
# 02-VirtualNetwork
#-------------------------------------------------------------------------------------

virtual_network_name = "myexample-dev-vnet"
address_space        = ["10.250.0.0/16"]

subnets = [
  {
    name           = "vm"
    address_prefix = "10.250.1.0/24"
  },
  {
    name           = "webapp"
    address_prefix = "10.250.2.0/24"
    delegation = {
      name = "delegation"
      service_delegation = {
        name    = "Microsoft.Web/serverFarms"
        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }
    }
  },
  {
    name           = "db"
    address_prefix = "10.250.3.0/24"
  },
  {
    name           = "storage"
    address_prefix = "10.250.4.0/24"
  },
  {
    name           = "funcapp"
    address_prefix = "10.250.5.0/24"
    delegation = {
      name = "delegation"
      service_delegation = {
        name    = "Microsoft.Web/serverFarms"
        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }
    }
  },
  {
    name           = "private-endpoint"
    address_prefix = "10.250.250.0/24"
  },
  {
    name           = "firewall"
    address_prefix = "10.250.254.0/24"
  },
  {
    name           = "GatewaySubnet"
    address_prefix = "10.250.255.0/24"
  }
]

#-------------------------------------------------------------------------------------------------
# 2.2-NetworkSecurityGroup
#------------------------------------------------------------------------------------------------

network_security_group_name = "myexample-dev-nsg"
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

#-------------------------------------------------------------------------------------------------
# 2.3-VirtualNetworkGateway
#-------------------------------------------------------------------------------------------------

virtual_network_gateway_name                        = "myexample-dev-vnet-gateway01"
virtual_network_gateway_public_ip_name              = "myexample-dev-vnet-gateway-ip"
gateway_type                                        = "Vpn"
vpn_type                                            = "RouteBased"
active_active                                       = false
virtual_network_gateway_sku                         = "VpnGw1"
virtual_network_gateway_public_ip_allocation_method = "Static"

#-----------------------------------------------------------------------------------------------
# 3.1-Virtual Machine  
#-----------------------------------------------------------------------------------------------

virtual_machine_public_ip_name              = "myexample-dev-vm-ip"
virtual_machine_public_ip_allocation_method = "Static"
virtual_machine_name                        = "myexampledevvm"
virtual_machine_size                        = "Standard_F2"
admin_username                              = "myexample"
admin_password                              = "Admin@123456"
network_interface_name                      = "myexample-dev-vm01-nic"
private_ip_address_allocation               = "Static"
private_ip_address_name                     = "myexample-dev-vm01-private-ip"
private_ip_address                          = "10.250.1.11"
os_disk_caching                             = "ReadWrite"
os_disk_storage_account_type                = "Standard_LRS"
virtual_machine_image_publisher             = "MicrosoftWindowsServer"
virtual_machine_image_offer                 = "WindowsServer"
virtual_machine_image_sku                   = "2022-datacenter"
virtual_machine_image_version               = "latest"

#-------------------------------------------------------------------------------------------------
# 3.2-ContainerRegistry
#-------------------------------------------------------------------------------------------------

container_registry_name       = "myexampledevacr"
container_registry_sku        = "Basic"
admin_enabled                 = true
public_network_access_enabled = true
quarantine_policy_enabled     = false
zone_redundancy_enabled       = false

#-----------------------------------------------------------------------------------------------
# 4.1-AppServicePlan
#-----------------------------------------------------------------------------------------------

service_plan_name = "myexample-dev-asp"
asp_os_type       = "Linux"
asp_sku_name      = "B2"

#-----------------------------------------------------------------------------------------------
# 4.2-AppService
#-----------------------------------------------------------------------------------------------

app_service = {
  frontend = {
    app_service_name = "myexample-dev-frontend"
    runtime = {
      node_version   = null
      python_version = null
      dotnet_version = "10.0"
    }
    app_settings = {
      DATABASE_URL                 = "@Microsoft.KeyVault(SecretUri=https://myexample-dev-bkd-kv.vault.azure.net/secrets/DBPASSWORD)"
      JWT_SECRET                   = "rUY98gz5Uq3elTgNtZZsqH1J9kTAF2UEUvhFapQXsU6eNlaPblZXFSksdJ+A+HM81e6gl5JQ/a/IN02jsMW1jw=="
      JWT_ISSUER                   = "myexample-auth-api"
      JWT_AUDIENCE                 = "myexample-client"
      JWT_TOKEN_LIFETIME_MINUTES   = "15"
      ALLOWED_HOSTS                = "*"
      LOGGING_DEFAULT              = "Information"
      LOGGING_MICROSOFT_ASPNETCORE = "Warning"
    }
    tags = {
      environment = "dev"
      team        = "devops"
    }
  }

  backend = {
    app_service_name = "myexample-dev-backend"
    runtime = {
      node_version   = "22-lts"
      python_version = null
      dotnet_version = null
    }
    app_settings = {
      DATABASE_URL                 = "@Microsoft.KeyVault(SecretUri=https://myexample-dev-bkd-kv.vault.azure.net/secrets/DBPASSWORD)"
      JWT_SECRET                   = "rUY98gz5Uq3elTgNtZZsqH1J9kTAF2UEUvhFapQXsU6eNlaPblZXFSksdJ+A+HM81e6gl5JQ/a/IN02jsMW1jw=="
      JWT_ISSUER                   = "myexample-auth-api"
      JWT_AUDIENCE                 = "myexample-client"
      JWT_TOKEN_LIFETIME_MINUTES   = "15"
      ALLOWED_HOSTS                = "*"
      LOGGING_DEFAULT              = "Information"
      LOGGING_MICROSOFT_ASPNETCORE = "Warning"
    }
    tags = {
      environment = "dev"
      team        = "devops"
    }
  }
}

#-----------------------------------------------------------------------------------------------
# 4.3-AppServiceContainer
#-----------------------------------------------------------------------------------------------

app_service_container = {
  frontend-container = {
    app_service_container_name = "myexample-dev-container-frontend"
    docker_image_name          = "nginx:alpine"
    app_settings = {
      DATABASE_URL                 = "@Microsoft.KeyVault(SecretUri=https://myexample-dev-bkd-kv.vault.azure.net/secrets/DBPASSWORD)"
      JWT_SECRET                   = "rUY98gz5Uq3elTgNtZZsqH1J9kTAF2UEUvhFapQXsU6eNlaPblZXFSksdJ+A+HM81e6gl5JQ/a/IN02jsMW1jw=="
      JWT_ISSUER                   = "myexample-auth-api"
      JWT_AUDIENCE                 = "myexample-client"
      JWT_TOKEN_LIFETIME_MINUTES   = "15"
      ALLOWED_HOSTS                = "*"
      LOGGING_DEFAULT              = "Information"
      LOGGING_MICROSOFT_ASPNETCORE = "Warning"
    }
    tags = {
      environment = "dev"
      team        = "devops"
    }
  }

  backend-container = {
    app_service_container_name = "myexample-dev-container-backend"
    docker_image_name          = "nginx:alpine"
    app_settings = {
      DATABASE_URL               = "@Microsoft.KeyVault(SecretUri=https://myexample-dev-bkd-kv.vault.azure.net/secrets/DBPASSWORD)"
      JWT_SECRET                 = "rUY98gz5Uq3elTgNtZZsqH1J9kTAF2UEUvhFapQXsU6eNlaPblZXFSksdJ+A+HM81e6gl5JQ/a/IN02jsMW1jw=="
      JWT_ISSUER                 = "myexample-auth-api"
      JWT_AUDIENCE               = "myexample-client"
      JWT_TOKEN_LIFETIME_MINUTES = "15"
      ALLOWED_HOSTS              = "*"
      LOGGING_DEFAULT            = "Information"
    }
    tags = {
      environment = "dev"
      team        = "devops"
    }
  }
}

#-----------------------------------------------------------------------------------------------
# 4.4-StaticWebApp
#-----------------------------------------------------------------------------------------------

static_webapp_name              = "myexample-dev-static-webapp"
static_webapp_sku_size          = "Free"
static_webapp_sku_tier          = "Free"
static_webapp_repository_url    = "https://myexample.co.in/github"
static_webapp_repository_branch = "develop"
static_webapp_repository_token  = "ABCDEFGHIJKLMNOPQ"
static_webapp_location          = "westus2"
static_webapp_api_location      = "api"
static_webapp_output_location   = "build"

#-----------------------------------------------------------------------------------------------
# 4.5-FunctionApp
#-----------------------------------------------------------------------------------------------

function_app_name              = "myexample-dev-funcapp"
dotnet_version                 = "dotnet6"
identity_type                  = "SystemAssigned"
run_from_package               = "1"
worker_runtime                 = "dotnet"
function_app_node_version      = "~14"
function_app_extension_version = "~4"
function_app_settings = {
  MyCustomSetting = "https://my-api.com/key"
}

#----------------------------------------------------------------------------------------------
# 4.6-FunctionAppFlexconsumption
#----------------------------------------------------------------------------------------------

function_app_flex_name                     = "myexample-dev-func-backend"
function_app_flex_service_plan_name        = "myexample-dev-backend-asp"
function_app_flex_storage_account_name     = "myexampledevfuncbackend"
function_app_flex_account_tier             = "Standard"
function_app_flex_account_replication_type = "LRS"
function_app_flex_sku_name                 = "FC1"
function_app_flex_os_type                  = "Linux"
function_app_flex_runtime_name             = "node"
function_app_flex_runtime_version          = "22"
function_app_flex_container_access_type    = "private"
function_app_flex_storage_container_name   = "myexample-dev-func-backend-container"

function_app_flex_app_settings = {
  MyCustomSetting = "https://my-api.com/key"
}

#-----------------------------------------------------------------------------------------------
# 5.1-StorageAccountStaticWebsite
#-----------------------------------------------------------------------------------------------

storage_account_web_name           = "myexampledevestorageweb"
account_tier                       = "Standard"
account_replication_type           = "LRS"
storage_account_index_document     = "index.html"
storage_account_error_404_document = "404.html"

#-----------------------------------------------------------------------------------------------
# 5.2-StorageAccount
#-----------------------------------------------------------------------------------------------

storage_accounts = {
  frontend = {
    name                     = "myexampledevfrontend"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    tags = {
      service = "backend"
    }
  }

  backend = {
    name                     = "myexampledevbackend"
    account_tier             = "Standard"
    account_replication_type = "GRS"
    tags = {
      service = "frontend"
    }
  }
}

#-----------------------------------------------------------------------------------------------
# 6.1-PostgreSQLFlexible
#-----------------------------------------------------------------------------------------------

postgresql_flexible_server_name = "myexample-dev-db-pg"
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
# 6.2-CosmosDB
#-----------------------------------------------------------------------------------------------

cosmosdb_account_name     = "myexample-dev-cosmosdb"
database_name             = "myexampledb"
consistency_level         = "Session"
max_interval_in_seconds   = 5
max_staleness_prefix      = 100
capabilities              = []
enable_automatic_failover = false

#-----------------------------------------------------------------------------------------------
# 7.2-DNSZone
#-----------------------------------------------------------------------------------------------

dns_zone_name = "myexample.co.in"
cname_records = null
txt_records   = null

#-----------------------------------------------------------------------------------------------  
# 7.1.1-PrivateDNSZone (PostgresSQLFlexible)
#-----------------------------------------------------------------------------------------------

private_dns_zones = {
  webapp = {
    name = "privatelink.azurewebsites.net"
  }

  blob = {
    name = "privatelink.blob.core.windows.net"
  }

  postgres = {
    name = "privatelink.postgres.database.azure.com"
  }

  keyvault = {
    name = "privatelink.vaultcore.azure.net"
  }
}

#-----------------------------------------------------------------------------------------------
# 8-PrivateEndpoint
#-----------------------------------------------------------------------------------------------
private_endpoints = {
  postgres = {
    name              = "myexample-dev-db-pe"
    service           = "postgres"
    subresource_names = ["postgresqlServer"]
  }

  storage-frontend = {
    name              = "myexample-dev-storage-frontend-pe"
    service           = "storage"
    instance          = "frontend"
    subresource_names = ["blob"]
  }

  storage-backend = {
    name              = "myexample-dev-storage-backend-pe"
    service           = "storage"
    instance          = "backend"
    subresource_names = ["blob"]
  }

  webapp-frontend = {
    name              = "myexample-dev-webapp-frontend-pe"
    service           = "webapp"
    instance          = "frontend"
    subresource_names = ["sites"]
  }

  webapp-backend = {
    name              = "myexample-dev-webapp-backend-pe"
    service           = "webapp"
    instance          = "backend"
    subresource_names = ["sites"]
  }

  webapp-container-frontend = {
    name              = "myexample-dev-webapp-container-frontend-pe"
    service           = "webapp-container"
    instance          = "frontend-container"
    subresource_names = ["sites"]
  }

  webapp-container-backend = {
    name              = "myexample-dev-webapp-container-backend-pe"
    service           = "webapp-container"
    instance          = "backend-container"
    subresource_names = ["sites"]
  }
}

/*
storage_frontend_private_endpoint_name = "myexample-dev-storage-frontend-pe"

app_service_frontend_private_endpoint_name = "myexample-dev-frontend-pe"
app_service_backend_private_endpoint_name  = "myexample-dev-backend-pe"

app_service_container_frontend_private_endpoint_name = "myexample-dev-frontend-container-pe"
app_service_container_backend_private_endpoint_name  = "myexample-dev-backend-container-pe"

keyvault_private_endpoint_name = "myexample-dev-keyvault-pe"
*/

#-----------------------------------------------------------------------------------------
# 9-RedisCache
#-----------------------------------------------------------------------------------------

cache_name                                = "myexample-dev-redis-cache"
capacity                                  = 2
family                                    = "C"
redis_cache_sku                           = "Basic"
redis_cache_public_network_access_enabled = true
redis_version                             = "6"
enable_non_ssl_port                       = false
minimum_tls_version                       = "1.2"
cluster_shard_count                       = 1

#------------------------------------------------------------------------------------------
# 10-KeyVault
#------------------------------------------------------------------------------------------

key_vault_name                       = "myexample-dev-backend-kv"
key_vault_tenant_id                  = "8fc36c8e-1077-4442-a9a3-ef873f9cc6c7"
key_vault_object_id                  = "myexample-dev-bkd-kv"
key_vault_sku_name                   = "standard"
key_vault_purge_protection_enabled   = false
key_vault_soft_delete_retention_days = "7"
key_vault_secrets = {
  DATABASEURL     = "https://myexample.db.com/"
  DATABASEREADURL = "https://myexample.db.com/"
  REDISHOST       = ""
  REDISPORT       = ""
  REDISTLS        = "true"
  SENTRYDSN       = ""
}

#-----------------------------------------------------------------------------------------------
# 11-CommunicationService
#-----------------------------------------------------------------------------------------------

communication_service_name      = "myexample-dev-acs"
email_service_name              = "myexample-dev-acs-email"
domain_name                     = "myexample.co.in"
enable_user_engagement_tracking = true
data_location                   = "United States"

#-------------------------------------------------------------------------------------------------
# 13.1-ServiceBus
#-------------------------------------------------------------------------------------------------

servicebus_namespace_name = "myexample-dev-sb-ns"
servicebus_sku            = "Standard"
servicebus_capacity       = null
servicebus_topic_name     = "myexample-dev-sb-topic"
servicebus_queue_name     = "myexample-dev-sb-queue"

#-----------------------------------------------------------------------------------------------
# 15.1-FrontDoor
#-----------------------------------------------------------------------------------------------

front_door_name     = "myexample-dev-afd"
front_door_sku_name = "Standard_AzureFrontDoor"

endpoint_frontend_name = "myexample-dev-frontend"
endpoint_backend_name  = "myexample-dev-backend"

origin_group_frontend_name = "myexample-dev-frontend-origin-group"
origin_group_backend_name  = "myexample-dev-backend-origin-group"

origin_frontend_name = "myexample-dev-frontend-origin"
origin_backend_name  = "myexample-dev-backend-origin"

origin_host_frontend_name = "myexample-dev-frontend.web.core.windows.net"
origin_host_backend_name  = "myexample-dev-backend-code.azurewebsites.net"

custome_domain_frontend_name = "myexample-dev-frontend"
custome_domain_backend_name  = "myexample-dev-backend"

host_custome_domain_frontend_name = "dev.myexample.co.in"
host_custome_domain_backend_name  = "api-dev.myexample.co.in"

route_frontend_name = "myexample-dev-frontend-route"
route_backend_name  = "myexample-dev-backend-route"

#----------------------------------------------------------------------------------------------
# 16-AppConfiguration
#----------------------------------------------------------------------------------------------

app_configurations = {
  backend = {
    name = "myexample-dev-appconfig-backend"

    key_values = {
      "Jwt:Issuer" = {
        value = "auth-api"
        label = "dev"
      }
    }
  }

  frontend = {
    name = "myexample-dev-appconfig-frontend"

    key_values = {
      "Api:BaseUrl" = {
        value = "https://api.myexample.com"
      }
    }
  }
}

#----------------------------------------------------------------------------------------------