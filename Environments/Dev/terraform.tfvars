#--------------------------------------------------------------------------------------------------
# Project Details
#--------------------------------------------------------------------------------------------------

project     = "myexample"
environment = "tst"

#--------------------------------------------------------------------------------------------------
# 00-Tags
#--------------------------------------------------------------------------------------------------

tags = {
  environment = "tst"
  projectname = "myexample"
}

#--------------------------------------------------------------------------------------------------
# 01-ResourceGroup
#--------------------------------------------------------------------------------------------------

resource_groups = {
  main = {
    name     = "myexample-dev-rg"
    location = "WEST US 3"
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
    name          = "myexample-dev-vnet1"
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
  windows-vm1 = {
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

  windows-vm2 = {
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
    kubernetes_version = "1.32.10"
    sku_tier           = "Free"

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
      projectname = "myexample"
    }
  }

  cluster2 = {
    name               = "myexample-tst-aks02"
    dns_prefix         = "myexample-tst-aks02"
    kubernetes_version = "1.32.10"
    sku_tier           = "Free"

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
      projectname = "myexample"
    }
  }
}

#--------------------------------------------------------------------------------------------------
# 03.05-AzureContainerApps
#--------------------------------------------------------------------------------------------------

container_app_environments = {
  main = {
    name = "myexample-tst-aca-env"
    workload_profiles = [
      {
        name                  = "Consumption"
        workload_profile_type = "Consumption"
      }
    ]
  }
}

container_apps = {
  containerapp01 = {
    name            = "myexample-tst-app01"
    environment_key = "main"
    revision_mode   = "Single"
    containers = [
      {
        name   = "hello-world"
        image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
        cpu    = 0.5
        memory = "1Gi"
      }
    ]
    ingress = {
      external_enabled = true
      target_port      = 80
      traffic_weight = [
        {
          latest_revision = true
          percentage      = 100
        }
      ]
    }
  }

  containerapp02 = {
    name            = "myexample-tst-app02"
    environment_key = "main"
    revision_mode   = "Single"
    containers = [
      {
        name   = "hello-world"
        image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
        cpu    = 0.5
        memory = "1Gi"
      }
    ]
    ingress = {
      external_enabled = true
      target_port      = 80
      traffic_weight = [
        {
          latest_revision = true
          percentage      = 100
        }
      ]
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
  linux-asp1 = {
    name                     = "myexample-tst-linux-asp1"
    os_type                  = "Linux"
    sku_name                 = "B1"
    per_site_scaling_enabled = false
    worker_count             = 1
    tags = {
      os = "linux"
    }
  },

  linux-asp2 = {
    name                     = "myexample-tst-linux-asp2"
    os_type                  = "Linux"
    sku_name                 = "B1"
    per_site_scaling_enabled = false
    worker_count             = 1
    tags = {
      os = "linux"
    }
  },

  windows-asp1 = {
    name                     = "myexample-tst-windows-asp1"
    os_type                  = "Windows"
    sku_name                 = "B1"
    per_site_scaling_enabled = false
    worker_count             = 1
    tags = {
      os = "windows"
    }
  }
}

#--------------------------------------------------------------------------------------------------
# 04.02-AppServiceLinux
#--------------------------------------------------------------------------------------------------

app_service_linux = {

  linux-webapp1 = {
    app_service_name = "myexample-tst-webapp1"
    service_plan_key = "linux-asp1"
    runtime = {
      dotnet_version = "8.0"
      node_version   = null
      python_version = null
    }
    app_settings = {}
    tags = {
      environment = "tst"
      project     = "myexample"
    }
  }

  linux-webapp2 = {
    app_service_name = "myexample-tst-webapp2"
    service_plan_key = "linux-asp2"
    runtime = {
      dotnet_version = null
      node_version   = "24-lts"
      python_version = null
    }
    app_settings = {}
    tags = {
      environment = "tst"
      project     = "myexample"
    }
  }
}

#--------------------------------------------------------------------------------------------------
# 04.03-AppServiceWindows
#--------------------------------------------------------------------------------------------------

app_service_windows = {
  windows-webapp1 = {
    app_service_name = "myexample-tst-win-webapp1"
    service_plan_key = "windows-asp1"
    runtime = {
      node_version   = null
      python_version = null
      dotnet_version = "v10.0"
    }
    app_settings = {}
    tags = {
      environment = "tst"
      project     = "myexample"
    }
  }
}

#--------------------------------------------------------------------------------------------------
# 04.04-AppServiceContainerLinux
#--------------------------------------------------------------------------------------------------

app_service_container_linux = {

  container-linux-webapp1 = {
    app_service_container_name = "myexample-tst-container-linux-webapp1"
    docker_image_name          = "nginx:alpine"
    service_plan_key           = "linux-asp1"
    app_settings               = {}

    tags = {
      environment = "tst"
      project     = "myexample"

    }
  },

  container-linux-webapp2 = {
    app_service_container_name = "myexample-tst-container-linux-webapp2"
    docker_image_name          = "nginx:alpine"
    service_plan_key           = "linux-asp2"
    app_settings               = {}

    tags = {
      environment = "tst"
      project     = "myexample"

    }
  }
}

#--------------------------------------------------------------------------------------------------
# 04.05-AppServiceContainerWindows
#--------------------------------------------------------------------------------------------------

app_service_container_windows = {
  container-windows-webapp1 = {
    app_service_container_name = "myexample-tst-container-windows-webapp1"
    docker_image_name          = "nginx:alpine"
    service_plan_key           = "windows-asp1"
    app_settings               = {}

    tags = {
      environment = "tst"
      project     = "myexample"
    }
  }
}

#--------------------------------------------------------------------------------------------------
# 04.06-FunctionsAppLinux
#--------------------------------------------------------------------------------------------------

function_app_linux = {
  functionapp-linux-webapp1 = {
    function_app_name    = "myexample-tst-lnx-funcwebapp1"
    service_plan_name    = "myexample-tst-lnx-funcwebapp1-asp"
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

function_app_windows = {
  functionapp-windows-webapp1 = {
    function_app_name    = "myexample-tst-win-funcwebapp1"
    service_plan_name    = "myexample-tst-win-funcwebapp1-asp"
    storage_account_name = "tstwinfuncappstg1"
    sku_name             = "B1"
    runtime_stack        = "dotnet"
    runtime_version      = "v8.0"
    always_on            = false
  }
}

#--------------------------------------------------------------------------------------------------
# 04.08-FunctionsAppFlexConsumption (OnlySupportLinux)
#--------------------------------------------------------------------------------------------------

function_app_flex = {
  function-flex1 = {
    function_app_name      = "myexample-tst-func-flex1"
    service_plan_name      = "myexample-tst-func-flex-asp1"
    storage_account_name   = "tstfuncflexstg1"
    storage_container_name = "tstfuncflexstg1"
    runtime_name           = "dotnet-isolated"
    runtime_version        = "8.0"
    os_type                = "Linux"
    maximum_instance_count = 40
    instance_memory_in_mb  = 4096
    sku_name               = "FC1"
  }

  function-flex2 = {
    function_app_name      = "myexample-tst-func-flex2"
    service_plan_name      = "myexample-tst-func-flex-asp2"
    storage_account_name   = "tstfuncflexstg2"
    storage_container_name = "tstfuncflexstg2"
    runtime_name           = "node"
    runtime_version        = "20"
    os_type                = "Linux"
    maximum_instance_count = 40
    instance_memory_in_mb  = 2048
    sku_name               = "FC1"
  }
}

#--------------------------------------------------------------------------------------------------
# 04.09-StaticWebApp
#--------------------------------------------------------------------------------------------------

static_web_app = {
  swa1 = {
    name              = "myexample-tst-static-webwebapp1"
    location          = "westus2"
    sku_tier          = "Free"
    sku_size          = "Free"
    repository_url    = "https://myexample.co.in/github"
    repository_branch = "tst"
    repository_token  = "ABCDEFGHIJKLMNOPQ"
  },

  swa2 = {
    name              = "myexample-tst-static-webwebapp2"
    location          = "westus2"
    sku_tier          = "Free"
    sku_size          = "Free"
    repository_url    = "https://myexample.co.in/github"
    repository_branch = "tst"
    repository_token  = "ABCDEFGHIJKLMNOPQ"
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
  postgres1 = {
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

  postgres2 = {
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
# 06.03-ManagedRedis
#--------------------------------------------------------------------------------------------------

managed_redis_instances = {
  main = {
    name     = "myexample-tst-managed-redis"
    sku_name = "Basic" # AMR SKU
    capacity = 1
    family   = "C"
  }
}

#--------------------------------------------------------------------------------------------------
# 07-DNSZone
#--------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------
# 07.01-PrivateDNSZone
#--------------------------------------------------------------------------------------------------

private_dns_zones = {
  sites = {
    name = "privatelink.azurewebsites.net" # for all webapps 
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

  cosmosdb = {
    name = "privatelink.documents.azure.com"
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
  postgres1 = {
    name              = "myexample-tst-db-postgres1-pe"
    service           = "postgres"
    instance          = "postgres1"
    subresource_names = ["postgresqlServer"]
  }

  postgres2 = {
    name              = "myexample-tst-db-postgres2-pe"
    service           = "postgres"
    instance          = "postgres2"
    subresource_names = ["postgresqlServer"]
  }

  cosmos1 = {
    name              = "myexample-tst-cosmosdb1-pe"
    service           = "cosmosdb"
    instance          = "cosmos1"
    subresource_names = ["sql"]
  }

  cosmos2 = {
    name              = "myexample-tst-cosmosdb2-pe"
    service           = "cosmosdb"
    instance          = "cosmos2"
    subresource_names = ["sql"]
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

  linux-webapp1 = {
    name              = "myexample-tst-linux-webapp1-pe"
    service           = "webapp-linux"
    instance          = "linux-webapp1"
    subresource_names = ["sites"]
  }

  linux-webapp2 = {
    name              = "myexample-tst-linux-webapp2-pe"
    service           = "webapp-linux"
    instance          = "linux-webapp2"
    subresource_names = ["sites"]
  }

  windows-webapp1 = {
    name              = "myexample-tst-windows-webapp1-pe"
    service           = "webapp-windows"
    instance          = "windows-webapp1"
    subresource_names = ["sites"]
  }

  container-linux-webapp1 = {
    name              = "myexample-tst-container-linux-webapp1-pe"
    service           = "webapp-container-linux"
    instance          = "container-linux-webapp1"
    subresource_names = ["sites"]
  }

  container-linux-webapp2 = {
    name              = "myexample-tst-container-linux-webapp2-pe"
    service           = "webapp-container-linux"
    instance          = "container-linux-webapp2"
    subresource_names = ["sites"]
  }

  container-windows-webapp1 = {
    name              = "myexample-tst-container-windows-webapp1-pe"
    service           = "webapp-container-windows"
    instance          = "container-windows-webapp1"
    subresource_names = ["sites"]
  }

  functionapp-linux-webapp1 = {
    name              = "myexample-tst-function-webapp1-pe"
    service           = "functionapp-linux"
    instance          = "functionapp-linux-webapp1"
    subresource_names = ["sites"]
  }

  functionapp-windows-webapp1 = {
    name              = "myexample-tst-function-webapp2-pe"
    service           = "functionapp-windows"
    instance          = "functionapp-windows-webapp1"
    subresource_names = ["sites"]
  }

  functionapp-flex1 = {
    name              = "myexample-tst-function-webapp1-pe"
    service           = "functionapp-flex"
    instance          = "function-flex1"
    subresource_names = ["sites"]
  }

  functionapp-flex2 = {
    name              = "myexample-tst-function-webapp2-pe"
    service           = "functionapp-flex"
    instance          = "function-flex2"
    subresource_names = ["sites"]
  }

  keyvault-backend = {
    name              = "myexample-tst-keyvault-backend-pe"
    instance          = "main-backend"
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
  main-backend = {
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

#   payments = {
#     name = "eg-payments-topic"
#   }
# }

# eventgrid_subscriptions = {
#   orders-webhook = {
#     topic_key        = "orders"
#     name             = "orders-webhook-sub"
#     webhook_endpoint = "https://example.com/webhook"
#     included_event_types = [
#       "Microsoft.Storage.BlobCreated"
#     ]
#   }

#   payments-function = {
#     topic_key         = "payments"
#     name              = "payments-func-sub"
#     azure_function_id = "/subscriptions/xxx/resourceGroups/rg/providers/Microsoft.Web/sites/app/functions/ProcessPayment"
#   }
# }

#--------------------------------------------------------------------------------------------------
# 14.01-ApplicationInsights
#--------------------------------------------------------------------------------------------------
app_insights = {
  main = {
    name             = "myexample-tst-appinsights"
    application_type = "web"
    tags = {
      usage = "web-tracking"
    }
  }
}

#--------------------------------------------------------------------------------------------------
# 14.02-Monitor-Log Analytics workspaces
#--------------------------------------------------------------------------------------------------

log_analytics_workspaces = {
  main = {
    name              = "myexample-tst-law"
    sku               = "PerGB2018"
    retention_in_days = 30
    tags = {
      usage = "central-logs"
    }
  }
}

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
  }
}

#--------------------------------------------------------------------------------------------------
# 15.02-FrontDoor
#--------------------------------------------------------------------------------------------------

front_doors = {
  main = {
    front_door_name                   = "myexample-tst-afd"
    front_door_sku_name               = "Standard_AzureFrontDoor"
    endpoint_frontend_name            = "myexample-tst-frontend"
    endpoint_backend_name             = "myexample-tst-backend"
    origin_group_frontend_name        = "myexample-tst-frontend-origin-group"
    origin_group_backend_name         = "myexample-tst-backend-origin-group"
    origin_frontend_name              = "myexample-tst-frontend-origin"
    origin_backend_name               = "myexample-tst-backend-origin"
    route_frontend_name               = "myexample-tst-frontend-route"
    route_backend_name                = "myexample-tst-backend-route"
    origin_frontend_key               = "swa1"                    # your frontend app name
    origin_backend_key                = "container-linux-webapp1" # you backend app name
    custome_domain_frontend_name      = "myexample-tst-frontend"
    custome_domain_backend_name       = "myexample-tst-backend"
    host_custome_domain_frontend_name = "tst.myexample.co.in"
    host_custome_domain_backend_name  = "api-tst.myexample.co.in"
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
# 17-ManagedIdentity
#--------------------------------------------------------------------------------------------------

managed_identities = {
  main = {
    name = "myexample-tst-uami"
    tags = {
      Environment = "tst"
      Projectname = "MyExample"
    }
  }
}

#--------------------------------------------------------------------------------------------------
# 19-AI
#--------------------------------------------------------------------------------------------------

openai_accounts = {
  main = {
    name     = "myexample-tst-openai"
    sku_name = "S0"
  }
}

openai_deployments = {
  gpt-4o = {
    name        = "gpt-4o"
    account_key = "main"
    model = {
      format  = "OpenAI"
      name    = "gpt-4o"
      version = "2024-05-13"
    }
    sku = {
      name     = "Standard"
      capacity = 10
    }
  }

  embedding = {
    name        = "text-embedding-3-small"
    account_key = "main"
    model = {
      format  = "OpenAI"
      name    = "text-embedding-3-small"
      version = "1"
    }
    sku = {
      name     = "Standard"
      capacity = 10
    }
  }
}

#-----------------------------------------------------------

