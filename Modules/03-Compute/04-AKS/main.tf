resource "azurerm_kubernetes_cluster" "aks" {
  for_each = var.aks_clusters

  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = each.value.dns_prefix
  kubernetes_version  = each.value.kubernetes_version
  sku_tier            = each.value.sku_tier

  private_cluster_enabled = each.value.private_cluster_enabled

  default_node_pool {
    name                         = each.value.default_node_pool.name
    node_count                   = each.value.default_node_pool.node_count
    vm_size                      = each.value.default_node_pool.vm_size
    os_disk_size_gb              = each.value.default_node_pool.os_disk_size_gb
    type                         = each.value.default_node_pool.type
    vnet_subnet_id               = each.value.default_node_pool.vnet_subnet_id
    only_critical_addons_enabled = each.value.default_node_pool.only_critical_addons_enabled
    zones                        = each.value.default_node_pool.zones
  }

  dynamic "identity" {
    for_each = each.value.identity != null ? [each.value.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "network_profile" {
    for_each = each.value.network_profile != null ? [each.value.network_profile] : []
    content {
      network_plugin = network_profile.value.network_plugin
      network_policy = network_profile.value.network_policy
      dns_service_ip = network_profile.value.dns_service_ip
      # docker_bridge_cidr = network_profile.value.docker_bridge_cidr
      service_cidr      = network_profile.value.service_cidr
      load_balancer_sku = network_profile.value.load_balancer_sku
    }
  }

  role_based_access_control_enabled = each.value.role_based_access_control_enabled

  tags = merge(var.tags, lookup(each.value, "tags", {}))
}
