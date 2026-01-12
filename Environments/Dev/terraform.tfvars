#------------------------------------------------------------------------------------
# Project Details
#------------------------------------------------------------------------------------
project     = "myexample"
environment = "tst"

#-------------------------------------------------------------------------------------
# 01-ResourceGroup
#-------------------------------------------------------------------------------------

resource_group_name = "myexample-tst-rg"
location            = "WEST US 3"

#-------------------------------------------------------------------------------------
# 02-VirtualNetwork
#-------------------------------------------------------------------------------------

virtual_network_name = "myexample-tst-vnet"
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

network_security_group_name = "myexample-tst-nsg"
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

virtual_network_gateway_name                        = "myexample-tst-vnet-gateway01"
virtual_network_gateway_public_ip_name              = "myexample-tst-vnet-gateway-ip"
gateway_type                                        = "Vpn"
vpn_type                                            = "RouteBased"
active_active                                       = false
virtual_network_gateway_sku                         = "VpnGw1"
virtual_network_gateway_public_ip_allocation_method = "Static"

#-----------------------------------------------------------------------------------------------
# 3.1-Virtual Machine  
#-----------------------------------------------------------------------------------------------

virtual_machine_public_ip_name              = "myexample-tst-vm-ip"
virtual_machine_public_ip_allocation_method = "Static"
virtual_machine_name                        = "myexampletstvm"
virtual_machine_size                        = "Standard_F2"
admin_username                              = "myexample"
admin_password                              = "Admin@123456"
network_interface_name                      = "myexample-tst-vm01-nic"
private_ip_address_allocation               = "Static"
private_ip_address_name                     = "myexample-tst-vm01-private-ip"
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

container_registry_name       = "myexampletstacr"
container_registry_sku        = "Basic"
admin_enabled                 = true
public_network_access_enabled = true
quarantine_policy_enabled     = false
zone_redundancy_enabled       = false

#-----------------------------------------------------------------------------------------------
# 4.1-AppServicePlan
#-----------------------------------------------------------------------------------------------

service_plans = {
  linux = {
    name                     = "myexample-tst-linux-asp"
    os_type                  = "Linux"
    sku_name                 = "B1"
    per_site_scaling_enabled = false
    worker_count             = 2
    tags = {
      os = "linux"
    }
  }

  windows = {
    name                     = "myexample-tst-win-asp"
    os_type                  = "Windows"
    sku_name                 = "B1"
    per_site_scaling_enabled = true
    worker_count             = 1
    tags = {
      os = "windows"
    }
  }
}


#-----------------------------------------------------------------------------------------------
# 4.2-AppService
#-----------------------------------------------------------------------------------------------

app_service = {
  frontend = {
    app_service_name = "myexample-tst-frontend"
    runtime = {
      node_version   = null
      python_version = null
      dotnet_version = "10.0"
    }
    app_settings = {
      DATABASE_URL                 = "@Microsoft.KeyVault(SecretUri=https://myexample-tst-bkd-kv.vault.azure.net/secrets/DBPASSWORD)"
      JWT_SECRET                   = "rUY98gz5Uq3elTgNtZZsqH1J9kTAF2UEUvhFapQXsU6eNlaPblZXFSksdJ+A+HM81e6gl5JQ/a/IN02jsMW1jw=="
      JWT_ISSUER                   = "myexample-auth-api"
      JWT_AUDIENCE                 = "myexample-client"
      JWT_TOKEN_LIFETIME_MINUTES   = "15"
      ALLOWED_HOSTS                = "*"
      LOGGING_DEFAULT              = "Information"
      LOGGING_MICROSOFT_ASPNETCORE = "Warning"
    }
    tags = {
      environment = "tst"
      team        = "tstops"
    }
  }

  backend = {
    app_service_name = "myexample-tst-backend"
    runtime = {
      node_version   = "22-lts"
      python_version = null
      dotnet_version = null
    }
    app_settings = {
      DATABASE_URL                 = "@Microsoft.KeyVault(SecretUri=https://myexample-tst-bkd-kv.vault.azure.net/secrets/DBPASSWORD)"
      JWT_SECRET                   = "rUY98gz5Uq3elTgNtZZsqH1J9kTAF2UEUvhFapQXsU6eNlaPblZXFSksdJ+A+HM81e6gl5JQ/a/IN02jsMW1jw=="
      JWT_ISSUER                   = "myexample-auth-api"
      JWT_AUDIENCE                 = "myexample-client"
      JWT_TOKEN_LIFETIME_MINUTES   = "15"
      ALLOWED_HOSTS                = "*"
      LOGGING_DEFAULT              = "Information"
      LOGGING_MICROSOFT_ASPNETCORE = "Warning"
    }
    tags = {
      environment = "tst"
      team        = "tstops"
    }
  }
}

app_service_windows = {
  frontend = {
    app_service_name = "myexample-tst-win-frontend"
    runtime = {
      node_version   = null
      python_version = null
      dotnet_version = "v10.0"
    }
    app_settings = {
      DATABASE_URL                 = "@Microsoft.KeyVault(SecretUri=https://myexample-tst-bkd-kv.vault.azure.net/secrets/DBPASSWORD)"
      JWT_SECRET                   = "rUY98gz5Uq3elTgNtZZsqH1J9kTAF2UEUvhFapQXsU6eNlaPblZXFSksdJ+A+HM81e6gl5JQ/a/IN02jsMW1jw=="
      JWT_ISSUER                   = "myexample-auth-api"
      JWT_AUDIENCE                 = "myexample-client"
      JWT_TOKEN_LIFETIME_MINUTES   = "15"
      ALLOWED_HOSTS                = "*"
      LOGGING_DEFAULT              = "Information"
      LOGGING_MICROSOFT_ASPNETCORE = "Warning"
    }
    tags = {
      environment = "tst"
      team        = "tstops"
    }
  }
}

#-----------------------------------------------------------------------------------------------
# 4.3-AppServiceContainer
#-----------------------------------------------------------------------------------------------

app_service_container = {
  frontend-container = {
    app_service_container_name = "myexample-tst-container-frontend"
    docker_image_name          = "nginx:alpine"
    app_settings = {
      DATABASE_URL                 = "@Microsoft.KeyVault(SecretUri=https://myexample-tst-bkd-kv.vault.azure.net/secrets/DBPASSWORD)"
      JWT_SECRET                   = "rUY98gz5Uq3elTgNtZZsqH1J9kTAF2UEUvhFapQXsU6eNlaPblZXFSksdJ+A+HM81e6gl5JQ/a/IN02jsMW1jw=="
      JWT_ISSUER                   = "myexample-auth-api"
      JWT_AUDIENCE                 = "myexample-client"
      JWT_TOKEN_LIFETIME_MINUTES   = "15"
      ALLOWED_HOSTS                = "*"
      LOGGING_DEFAULT              = "Information"
      LOGGING_MICROSOFT_ASPNETCORE = "Warning"
    }
    tags = {
      environment = "tst"
      team        = "tstops"
    }
  }

  backend-container = {
    app_service_container_name = "myexample-tst-container-backend"
    docker_image_name          = "nginx:alpine"
    app_settings = {
      DATABASE_URL               = "@Microsoft.KeyVault(SecretUri=https://myexample-tst-bkd-kv.vault.azure.net/secrets/DBPASSWORD)"
      JWT_SECRET                 = "rUY98gz5Uq3elTgNtZZsqH1J9kTAF2UEUvhFapQXsU6eNlaPblZXFSksdJ+A+HM81e6gl5JQ/a/IN02jsMW1jw=="
      JWT_ISSUER                 = "myexample-auth-api"
      JWT_AUDIENCE               = "myexample-client"
      JWT_TOKEN_LIFETIME_MINUTES = "15"
      ALLOWED_HOSTS              = "*"
      LOGGING_DEFAULT            = "Information"
    }
    tags = {
      environment = "tst"
      team        = "tstops"
    }
  }
}

#-----------------------------------------------------------------------------------------------
# 4.4-StaticWebApp
#-----------------------------------------------------------------------------------------------

static_webapp_name              = "myexample-tst-static-webapp"
static_webapp_sku_size          = "Free"
static_webapp_sku_tier          = "Free"
static_webapp_repository_url    = "https://myexample.co.in/github"
static_webapp_repository_branch = "tstelop"
static_webapp_repository_token  = "ABCDEFGHIJKLMNOPQ"
static_webapp_location          = "westus2"
static_webapp_api_location      = "api"
static_webapp_output_location   = "build"

#-----------------------------------------------------------------------------------------------
# 4.5-FunctionApp
#-----------------------------------------------------------------------------------------------

function_app_name              = "myexample-tst-funcapp"
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

function_apps = {
  func-1 = {
    function_app_name      = "myexample-tst-func1"
    service_plan_name      = "myexample-tst-func1-asp"
    storage_account_name   = "tstfunc1storage"
    storage_container_name = "tstfunc1storage"
    runtime_name           = "dotnet-isolated"
    runtime_version        = "8.0"
    os_type                = "Linux"
    maximum_instance_count = 40
    instance_memory_in_mb  = 4096
  }

  func-2 = {
    function_app_name      = "myexample-tst-func2"
    service_plan_name      = "myexample-tst-func2-asp"
    storage_account_name   = "tstfunc2storage"
    storage_container_name = "tstfunc2storage"
    runtime_name           = "node"
    runtime_version        = "20"
    os_type                = "Linux"
    maximum_instance_count = 40
    instance_memory_in_mb  = 2048
  }
}

#-----------------------------------------------------------------------------------------------
# 5.2-StorageAccount
#-----------------------------------------------------------------------------------------------

storage_accounts = {
  frontend = {
    name                     = "myexampletstfrontend"
    account_tier             = "Standard"
    account_replication_type = "LRS"

    static_website = {
      index_document     = "index.html"
      error_404_document = "404.html"
    }

    tags = {
      app = "frontend"
    }
  }

  backend = {
    name                     = "myexampletstbackend"
    account_tier             = "Standard"
    account_replication_type = "GRS"
    tags = {
      app = "backend"
    }
  }
}

#-----------------------------------------------------------------------------------------------
# 6.1-PostgreSQLFlexible
#-----------------------------------------------------------------------------------------------

postgres_sql = {
  server1 = {
    name                         = "myexample-tst-pgsql-svr01"
    sku_name                     = "B_Standard_B2ms"
    tier                         = "Burstable"
    version                      = "15"
    storage_mb                   = 131072 # 128 GB (max allowed for burstable)
    zone                         = "1"
    admin_login                  = "pgadmin"
    backup_retention_days        = 7
    geo_redundant_backup_enabled = false

    databases = {
      testdb = {
        charset   = "UTF8"
        collation = "en_US.utf8"
      }
    }
  },

  server2 = {
    name                         = "myexample-tst-pgsql-svr02"
    sku_name                     = "B_Standard_B2ms"
    tier                         = "Burstable"
    version                      = "15"
    storage_mb                   = 131072 # 128 GB (max allowed for burstable)
    zone                         = "2"
    admin_login                  = "pgadmin"
    backup_retention_days        = 7
    geo_redundant_backup_enabled = false

    databases = {
      testdb = {
        charset   = "UTF8"
        collation = "en_US.utf8"
      }
    }
  }
}

tags = {
  environment = "prod"
  owner       = "platform"
}

#-----------------------------------------------------------------------------------------------
# 6.2-CosmosDB
#-----------------------------------------------------------------------------------------------

cosmosdb_account_name     = "myexample-tst-cosmosdb"
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
  postgres-server1 = {
    name              = "myexample-tst-db-svr01-pe"
    service           = "postgres"
    instance          = "server1"
    subresource_names = ["postgresqlServer"]
  }

  postgres-server2 = {
    name              = "myexample-tst-db-svr02-pe"
    service           = "postgres"
    instance          = "server2"
    subresource_names = ["postgresqlServer"]
  }

  storage-frontend = {
    name              = "myexample-tst-storage-frontend-pe"
    service           = "storage"
    instance          = "frontend"
    subresource_names = ["blob"]
  }

  storage-backend = {
    name              = "myexample-tst-storage-backend-pe"
    service           = "storage"
    instance          = "backend"
    subresource_names = ["blob"]
  }

  webapp-frontend = {
    name              = "myexample-tst-webapp-frontend-pe"
    service           = "webapp"
    instance          = "frontend"
    subresource_names = ["sites"]
  }

  webapp-backend = {
    name              = "myexample-tst-webapp-backend-pe"
    service           = "webapp"
    instance          = "backend"
    subresource_names = ["sites"]
  }

  webapp-container-frontend = {
    name              = "myexample-tst-webapp-container-frontend-pe"
    service           = "webapp-container"
    instance          = "frontend-container"
    subresource_names = ["sites"]
  }

  webapp-container-backend = {
    name              = "myexample-tst-webapp-container-backend-pe"
    service           = "webapp-container"
    instance          = "backend-container"
    subresource_names = ["sites"]
  }

  keyvault-backend = {
    name              = "myexample-tst-keyvault-backend-pe"
    service           = "keyvault"
    subresource_names = ["vault"]
  }
}

#-----------------------------------------------------------------------------------------
# 9-RedisCache
#-----------------------------------------------------------------------------------------

cache_name                                = "myexample-tst-redis-cache"
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

key_vault_name                       = "myexample-tst-backend-kv"
key_vault_object_id                  = "myexample-tst-bkd-kv"
key_vault_sku_name                   = "standard"
key_vault_purge_protection_enabled   = false
key_vault_soft_delete_retention_days = "7"
key_vault_secrets = {
  DATABASEURL     = "https://myexample.db.com/"
  DATABASEREADURL = "https://myexample.db.com/"
  REDISHOST       = ""
  REDISPORT       = ""
  REDISTLS        = "true"
  SENTRYDSN       = "123"
}

#-----------------------------------------------------------------------------------------------
# 11-CommunicationService
#-----------------------------------------------------------------------------------------------

communication_service_name      = "myexample-tst-acs"
email_service_name              = "myexample-tst-acs-email"
domain_name                     = "myexample.co.in"
enable_user_engagement_tracking = true
data_location                   = "United States"

#-------------------------------------------------------------------------------------------------
# 13.1-ServiceBus
#-------------------------------------------------------------------------------------------------

servicebus_namespace_name = "myexample-tst-sb-ns"
servicebus_sku            = "Standard"
servicebus_capacity       = null
servicebus_topic_name     = "myexample-tst-sb-topic"
servicebus_queue_name     = "myexample-tst-sb-queue"

#-----------------------------------------------------------------------------------------------
# 13.3-EventGrid
#-----------------------------------------------------------------------------------------------

eventgrid_topics = {
  orders = {
    name     = "eg-orders-topic"
    identity = true
    tags = {
      env = "dev"
    }
  }

  payments = {
    name = "eg-payments-topic"
  }
}

eventgrid_subscriptions = {
  orders-webhook = {
    topic_key        = "orders"
    name             = "orders-webhook-sub"
    webhook_endpoint = "https://example.com/webhook"
    included_event_types = [
      "Microsoft.Storage.BlobCreated"
    ]
  }

  payments-function = {
    topic_key          = "payments"
    name               = "payments-func-sub"
    azure_function_id  = "/subscriptions/xxx/resourceGroups/rg/providers/Microsoft.Web/sites/app/functions/ProcessPayment"
  }
}

#-----------------------------------------------------------------------------------------------
# 15.1-FrontDoor
#-----------------------------------------------------------------------------------------------

front_door_name     = "myexample-tst-afd"
front_door_sku_name = "Standard_AzureFrontDoor"

endpoint_frontend_name = "myexample-tst-frontend"
endpoint_backend_name  = "myexample-tst-backend"

origin_group_frontend_name = "myexample-tst-frontend-origin-group"
origin_group_backend_name  = "myexample-tst-backend-origin-group"

origin_frontend_name = "myexample-tst-frontend-origin"
origin_backend_name  = "myexample-tst-backend-origin"

origin_host_frontend_name = "myexample-tst-frontend.web.core.windows.net"
origin_host_backend_name  = "myexample-tst-backend-code.azurewebsites.net"

custome_domain_frontend_name = "myexample-tst-frontend"
custome_domain_backend_name  = "myexample-tst-backend"

host_custome_domain_frontend_name = "tst.myexample.co.in"
host_custome_domain_backend_name  = "api-tst.myexample.co.in"

route_frontend_name = "myexample-tst-frontend-route"
route_backend_name  = "myexample-tst-backend-route"

#----------------------------------------------------------------------------------------------
# 16-AppConfiguration
#----------------------------------------------------------------------------------------------

app_configurations = {
  backend = {
    name = "myexample-tst-appconfig-backend"

    key_values = {
      "Jwt:Issuer" = {
        value = "auth-api"
        label = "tst"
      }
    }
  }

  frontend = {
    name = "myexample-tst-appconfig-frontend"

    key_values = {
      "Api:BaseUrl" = {
        value = "https://api.myexample.com"
      }
    }
  }
}

#----------------------------------------------------------------------------------------------