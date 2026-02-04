#--------------------------------------------------------------------------------------------------
# Project Details
#--------------------------------------------------------------------------------------------------

project     = "myexample"
environment = "tst"

#--------------------------------------------------------------------------------------------------
# 01-ResourceGroup
#--------------------------------------------------------------------------------------------------

resource_groups = {
  main = {
    name     = "myexample-tst-rg"
    location = "WEST US 3"
    tags     = {}
  },

  dev = {
    name     = "myexample-dev-rg"
    location = "WEST US 2"
    tags     = {}
  }
}

#--------------------------------------------------------------------------------------------------
# 02-Networking
#--------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------
# 02.01-VirtualNetwork
#--------------------------------------------------------------------------------------------------

virtual_networks = {
  main = {
    name          = "myexample-tst-vnet1"
    address_space = ["10.250.0.0/16"]
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
        name           = "aks"
        address_prefix = "10.250.253.0/24"
      },
      {
        name           = "GatewaySubnet"
        address_prefix = "10.250.255.0/24"
      }
    ]
  },

  vnet2 = {
    name          = "myexample-tst-vnet2"
    address_space = ["10.251.0.0/16"]
    subnets = [
      {
        name           = "vm"
        address_prefix = "10.251.1.0/24"
      },
    ]
  }
}

#--------------------------------------------------------------------------------------------------
# 02.02-NetworkSecurityGroup
#--------------------------------------------------------------------------------------------------

network_security_groups = {
  main = {
    name = "myexample-tst-nsg"
    rules = [
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
    subnet_names = ["vm", "webapp", "db"]
  }
}

#--------------------------------------------------------------------------------------------------
# 02.03-VirtualNetworkGateway
#--------------------------------------------------------------------------------------------------

virtual_network_gateways = {
  gw1 = {
    name                        = "myexample-tst-vnet-gateway01"
    public_ip_name              = "myexample-tst-vnet-gateway-ip"
    gateway_type                = "Vpn"
    vpn_type                    = "RouteBased"
    active_active               = false
    sku                         = "VpnGw1"
    public_ip_allocation_method = "Static"
  }
}

#--------------------------------------------------------------------------------------------------
# 03-Compute
#--------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------
# 03.01-VirtualMachineWindows
#--------------------------------------------------------------------------------------------------

virtual_machines_windows = {
  vm1 = {
    name           = "myexampletstvm1"
    size           = "Standard_F2"
    admin_username = "myexample"

    public_ip_name               = "myexample-tst-vm1-ip"
    public_ip_allocation_method  = "Static"
    network_interface_name       = "myexample-tst-vm1-nic"
    private_ip_name              = "myexample-tst-vm1-private-ip"
    private_ip_allocation        = "Dynamic"
    os_disk_caching              = "ReadWrite"
    os_disk_storage_account_type = "Standard_LRS"
    image_publisher              = "MicrosoftWindowsServer"
    image_offer                  = "WindowsServer"
    image_sku                    = "2022-datacenter"
    image_version                = "latest"
  },

  vm2 = {
    name           = "myexampletstvm2"
    size           = "Standard_F2"
    admin_username = "myexample"

    public_ip_name               = "myexample-tst-vm2-ip"
    public_ip_allocation_method  = "Static"
    network_interface_name       = "myexample-tst-vm2-nic"
    private_ip_name              = "myexample-tst-vm2-private-ip"
    private_ip_allocation        = "Dynamic"
    os_disk_caching              = "ReadWrite"
    os_disk_storage_account_type = "Standard_LRS"
    image_publisher              = "MicrosoftWindowsServer"
    image_offer                  = "WindowsServer"
    image_sku                    = "2022-datacenter"
    image_version                = "latest"
  }
}

#--------------------------------------------------------------------------------------------------
# 03.01-VirtualMachineLinux
#--------------------------------------------------------------------------------------------------

virtual_machines_linux = {
  linux-vm1 = {
    name           = "myexampletstlinux1"
    size           = "Standard_F2"
    admin_username = "azureuser"

    public_ip_name               = "myexample-tst-linux-vm1-ip"
    public_ip_allocation_method  = "Static"
    network_interface_name       = "myexample-tst-linux-vm1-nic"
    private_ip_name              = "myexample-tst-linux-vm1-private-ip"
    private_ip_allocation        = "Dynamic"
    os_disk_caching              = "ReadWrite"
    os_disk_storage_account_type = "Standard_LRS"
    image_publisher              = "Canonical"
    image_offer                  = "0001-com-ubuntu-server-jammy"
    image_sku                    = "22_04-lts"
    image_version                = "latest"
  }
}

#--------------------------------------------------------------------------------------------------
# 03.02-ContainerRegistry
#--------------------------------------------------------------------------------------------------

container_registries = {
  acr1 = {
    name                          = "myexampletstacr01"
    sku                           = "Basic"
    admin_enabled                 = true
    public_network_access_enabled = true
    quarantine_policy_enabled     = false
    zone_redundancy_enabled       = false
  },

  acr2 = {
    name                          = "myexampletstacr02"
    sku                           = "Basic"
    admin_enabled                 = true
    public_network_access_enabled = true
    quarantine_policy_enabled     = false
    zone_redundancy_enabled       = false
  }
}


#--------------------------------------------------------------------------------------------------
# 03.03-AKS
#--------------------------------------------------------------------------------------------------

aks_clusters = {
  cluster1 = {
    name               = "myexample-tst-aks01"
    dns_prefix         = "myexample-tst-aks01"
    kubernetes_version = "1.28.5"
    sku_tier           = "Standard"

    default_node_pool = {
      name            = "default"
      node_count      = 2
      vm_size         = "Standard_DS2_v2"
      type            = "VirtualMachineScaleSets"
      os_disk_size_gb = 50
      subnet_name     = "aks"
    }

    identity = {
      type = "SystemAssigned"
    }

    network_profile = {
      network_plugin    = "azure"
      load_balancer_sku = "standard"
    }

    tags = {
      environment = "tst"
    }
  }
}

#--------------------------------------------------------------------------------------------------
# 04-Web
#--------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------
# 04.01-AppServicePlan
#--------------------------------------------------------------------------------------------------

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

#--------------------------------------------------------------------------------------------------
# 04.02-AppServiceLinux
#--------------------------------------------------------------------------------------------------

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

#--------------------------------------------------------------------------------------------------
# 04.03-AppServiceContainer
#--------------------------------------------------------------------------------------------------

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
      projectname = "myexample"
      environment = "tst"
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
      projectname = "myexample"
      environment = "tst"
    }
  }
}

#--------------------------------------------------------------------------------------------------
# 04.04-AppServiceWindows
#--------------------------------------------------------------------------------------------------

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

#--------------------------------------------------------------------------------------------------
# 04.05-StaticWebApp
#--------------------------------------------------------------------------------------------------

static_web_apps = {
  app1 = {
    name              = "myexample-tst-static-webapp1"
    location          = "westus2"
    sku_tier          = "Free"
    sku_size          = "Free"
    repository_url    = "https://myexample.co.in/github"
    repository_branch = "tstelop"
    repository_token  = "ABCDEFGHIJKLMNOPQ"
  },

  app2 = {
    name              = "myexample-tst-static-webapp2"
    location          = "westus2"
    sku_tier          = "Free"
    sku_size          = "Free"
    repository_url    = "https://myexample.co.in/github"
    repository_branch = "tstelop"
    repository_token  = "ABCDEFGHIJKLMNOPQ"
  }
}

#--------------------------------------------------------------------------------------------------
# 04.06-FunctionsAppLinux
#--------------------------------------------------------------------------------------------------

function_apps_linux = {
  func-linux = {
    function_app_name    = "myexample-tst-lnx-funcapp1"
    service_plan_name    = "myexample-tst-lnx-funcapp1-asp"
    storage_account_name = "tstlnxfuncappstg1"
    sku_name             = "B1"
    runtime_stack        = "dotnet"
    runtime_version      = "8.0"
    always_on            = true
  }
}

#--------------------------------------------------------------------------------------------------
# 04.07-FunctionsAppWindows
#--------------------------------------------------------------------------------------------------

function_apps_windows = {
  func-win = {
    function_app_name    = "myexample-tst-win-funcapp1"
    service_plan_name    = "myexample-tst-win-funcapp1-asp"
    storage_account_name = "tstwinfuncappstg1"
    sku_name             = "B1"
    runtime_stack        = "dotnet"
    runtime_version      = "v8.0"
    always_on            = false
  }
}

#--------------------------------------------------------------------------------------------------
# 04.08-FunctionsAppFlexConsumption
#--------------------------------------------------------------------------------------------------

function_apps_flex = {
  func-1 = {
    function_app_name      = "myexample-tst-func1"
    service_plan_name      = "myexample-tst-func1-asp"
    storage_account_name   = "tstfuncflexstg1"
    storage_container_name = "tstfuncflexstg1"
    runtime_name           = "dotnet-isolated"
    runtime_version        = "8.0"
    os_type                = "Linux"
    maximum_instance_count = 40
    instance_memory_in_mb  = 4096
  }

  func-2 = {
    function_app_name      = "myexample-tst-func2"
    service_plan_name      = "myexample-tst-func2-asp"
    storage_account_name   = "tstfuncflexstg2"
    storage_container_name = "tstfuncflexstg2"
    runtime_name           = "node"
    runtime_version        = "20"
    os_type                = "Linux"
    maximum_instance_count = 40
    instance_memory_in_mb  = 2048
  }
}

#--------------------------------------------------------------------------------------------------
# 05-StorageAccount
#--------------------------------------------------------------------------------------------------

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

#--------------------------------------------------------------------------------------------------
# 06-Database
#--------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------
# 06.01-PostgresSQLFlexible
#--------------------------------------------------------------------------------------------------

postgres_sql = {
  server1 = {
    name                         = "myexample-tst-pgsql-svr01"
    sku_name                     = "B_Standard_B1ms"
    tier                         = "Burstable"
    version                      = "18"
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
    version                      = "18"
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

#--------------------------------------------------------------------------------------------------
# 06.02-CosmosDB
#--------------------------------------------------------------------------------------------------

cosmos_dbs = {
  cosmos1 = {
    name                    = "myexample-tst-cosmosdb1"
    database_name           = "myexampledb"
    consistency_level       = "Session"
    max_interval_in_seconds = 5
    max_staleness_prefix    = 100
    capabilities            = []
    tags                    = {}
  }

  cosmos2 = {
    name                    = "myexample-tst-cosmosdb2"
    database_name           = "myexampledb"
    consistency_level       = "Session"
    max_interval_in_seconds = 5
    max_staleness_prefix    = 100
    capabilities            = []
    tags                    = {}
  }
}

#--------------------------------------------------------------------------------------------------
# 07-DNSZone
#--------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------
# 07.01-PrivateDNSZone
#--------------------------------------------------------------------------------------------------

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

#--------------------------------------------------------------------------------------------------
# 07.02-DNSZone
#--------------------------------------------------------------------------------------------------

dns_zones = {
  myexample-in = {
    name          = "myexample.co.in"
    cname_records = null
    txt_records   = null
  },

  myexample-us = {
    name          = "myexample.co.us"
    cname_records = null
    txt_records   = null
  }
}

#--------------------------------------------------------------------------------------------------
# 08-PrivateEndPoints
#--------------------------------------------------------------------------------------------------

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

#--------------------------------------------------------------------------------------------------
# 09-CacheRedis
#--------------------------------------------------------------------------------------------------

redis_caches = {
  redis1 = {
    name                          = "myexample-tst-redis-cache1"
    capacity                      = 2
    family                        = "C"
    sku                           = "Basic"
    non_ssl_port_enabled          = false
    minimum_tls_version           = "1.2"
    cluster_shard_count           = 1
    public_network_access_enabled = true
    redis_version                 = "6"
  }

  redis2 = {
    name                          = "myexample-tst-redis-cache2"
    capacity                      = 2
    family                        = "C"
    sku                           = "Basic"
    non_ssl_port_enabled          = false
    minimum_tls_version           = "1.2"
    cluster_shard_count           = 1
    public_network_access_enabled = true
    redis_version                 = "6"
  }
}

#--------------------------------------------------------------------------------------------------
# 10-KeyVault
#--------------------------------------------------------------------------------------------------

key_vaults = {
  backend = {
    name                        = "myexample-tst-be-kv"
    sku_name                    = "standard"
    soft_delete_retention_days  = 7
    purge_protection_enabled    = false
    enable_rbac_authorization   = true
    enabled_for_disk_encryption = true
    network_acls                = null
    tags                        = {}
  },

  frontend = {
    name                        = "myexample-tst-fe-kv"
    sku_name                    = "standard"
    soft_delete_retention_days  = 7
    purge_protection_enabled    = false
    enable_rbac_authorization   = true
    enabled_for_disk_encryption = true
    network_acls                = null
    tags                        = {}
  }
}

#--------------------------------------------------------------------------------------------------
# 11-CommunicationServices
#--------------------------------------------------------------------------------------------------

communication_services = {
  service1 = {
    communication_service_name      = "myexample-tst-acs"
    email_service_name              = "myexample-tst-acs-email"
    domain_name                     = "myexample.co.in"
    enable_user_engagement_tracking = true
    data_location                   = "United States"
    tags                            = {}
  }
}

#--------------------------------------------------------------------------------------------------
# 12-NotificationsHub
#--------------------------------------------------------------------------------------------------

notification_hub_namespaces = {
  nh1 = {
    name = "myexample-tst-nh-ns01"
    sku  = "Free"
    tags = {}

    notification_hubs = {
      hub1 = {
        name = "myexample-tst-nh-hub1"
      }
    }
  }
}

#--------------------------------------------------------------------------------------------------
# 13-Integration
#--------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------
# 13.01-ServiceBus
#--------------------------------------------------------------------------------------------------

service_buses = {
  sb1 = {
    name       = "myexample-tst-sb-ns01"
    sku        = "Standard"
    topic_name = "myexample-tst-sb-topic"
    queue_name = "myexample-tst-sb-queue"
    tags       = {}
  },

  sb2 = {
    name       = "myexample-tst-sb-ns02"
    sku        = "Standard"
    topic_name = "myexample-tst-sb-topic"
    queue_name = "myexample-tst-sb-queue"
    tags       = {}
  }
}

#--------------------------------------------------------------------------------------------------
# 13.02-EventHub
#--------------------------------------------------------------------------------------------------

eventhub_namespaces = {
  eh1 = {
    name = "myexample-tst-eh-ns01"
    sku  = "Standard"
    tags = {}

    eventhubs = {
      hub1 = {
        name              = "myexample-tst-eh-hub1"
        partition_count   = 2
        message_retention = 1
      }
    }
  }
}

#--------------------------------------------------------------------------------------------------
# 13.03-EventGrid (commented)
#--------------------------------------------------------------------------------------------------

# eventgrid_topics = {
#   orders = {
#     name     = "eg-orders-topic"
#     identity = true
#     tags = {
#       env = "dev"
#     }
#   }
#
#   payments = {
#     name = "eg-payments-topic"
#   }
# }
#
# eventgrid_subscriptions = {
#   orders-webhook = {
#     topic_key        = "orders"
#     name             = "orders-webhook-sub"
#     webhook_endpoint = "https://example.com/webhook"
#     included_event_types = [
#       "Microsoft.Storage.BlobCreated"
#     ]
#   }
#
#   payments-function = {
#     topic_key         = "payments"
#     name              = "payments-func-sub"
#     azure_function_id = "/subscriptions/xxx/resourceGroups/rg/providers/Microsoft.Web/sites/app/functions/ProcessPayment"
#   }
# }

#--------------------------------------------------------------------------------------------------
# 15-LoadBalancer
#--------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------
# 15.01-FrontDoorWafPolicy
#--------------------------------------------------------------------------------------------------

waf_policies = {
  main = {
    name     = "myexampletstwafpolicymain"
    sku_name = "Standard_AzureFrontDoor"
    mode     = "Prevention"
    enabled  = true
    # Note: Standard SKU only supports custom rules, not managed rule sets
    # Managed rules require Premium SKU
  },

  dev = {
    name     = "myexampletstwafpolicydev"
    sku_name = "Standard_AzureFrontDoor"
    mode     = "Prevention"
    enabled  = true
    # Note: Standard SKU only supports custom rules, not managed rule sets
    # Managed rules require Premium SKU
  }
}

#--------------------------------------------------------------------------------------------------
# 15.02-FrontDoor
#--------------------------------------------------------------------------------------------------

front_doors = {
  main = {
    front_door_name            = "myexample-tst-afd"
    front_door_sku_name        = "Standard_AzureFrontDoor"
    endpoint_frontend_name     = "myexample-tst-frontend"
    endpoint_backend_name      = "myexample-tst-backend"
    origin_group_frontend_name = "myexample-tst-frontend-origin-group"
    origin_group_backend_name  = "myexample-tst-backend-origin-group"
    origin_frontend_name       = "myexample-tst-frontend-origin"
    origin_backend_name        = "myexample-tst-backend-origin"
    route_frontend_name        = "myexample-tst-frontend-route"
    route_backend_name         = "myexample-tst-backend-route"
    # Dynamic hostnames (use container_key for containers, webapp_key for standard App Service)
    origin_frontend_container_key     = "frontend-container"
    origin_backend_container_key      = "backend-container"
    origin_frontend_webapp_key        = "frontend"
    origin_backend_webapp_key         = "backend"
    custome_domain_frontend_name      = "myexample-tst-frontend"
    custome_domain_backend_name       = "myexample-tst-backend"
    host_custome_domain_frontend_name = "tst.myexample.co.in"
    host_custome_domain_backend_name  = "api-tst.myexample.co.in"
    enable_waf                        = true
  },

  dev = {
    front_door_name            = "myexample-dev-afd"
    front_door_sku_name        = "Standard_AzureFrontDoor"
    endpoint_frontend_name     = "myexample-dev-frontend"
    endpoint_backend_name      = "myexample-dev-backend"
    origin_group_frontend_name = "myexample-dev-frontend-origin-group"
    origin_group_backend_name  = "myexample-dev-backend-origin-group"
    origin_frontend_name       = "myexample-dev-frontend-origin"
    origin_backend_name        = "myexample-dev-backend-origin"
    route_frontend_name        = "myexample-dev-frontend-route"
    route_backend_name         = "myexample-dev-backend-route"
    # Dynamic hostnames (use container_key for containers, webapp_key for standard App Service)
    origin_frontend_container_key     = "frontend-container"
    origin_backend_container_key      = "backend-container"
    origin_frontend_webapp_key        = "frontend"
    origin_backend_webapp_key         = "backend"
    custome_domain_frontend_name      = "myexample-dev-frontend"
    custome_domain_backend_name       = "myexample-dev-backend"
    host_custome_domain_frontend_name = "dev.myexample.co.in"
    host_custome_domain_backend_name  = "api-dev.myexample.co.in"
    enable_waf                        = true
  }
}

#--------------------------------------------------------------------------------------------------
# 16-AppConfiguration
#--------------------------------------------------------------------------------------------------

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

#--------------------------------------------------------------------------------------------------
