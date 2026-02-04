variable "location" {
  description = "Azure Region"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to resources (inclusive)"
  type        = map(string)
  default     = {}
}

variable "aks_clusters" {
  description = "Map of variables for AKS clusters to create"
  type = map(object({
    name                    = string
    dns_prefix              = string
    kubernetes_version      = optional(string)
    private_cluster_enabled = optional(bool, false)
    sku_tier                = optional(string, "Free")

    default_node_pool = object({
      name                         = string
      node_count                   = optional(number, 1)
      vm_size                      = string
      os_disk_size_gb              = optional(number)
      type                         = optional(string, "VirtualMachineScaleSets")
      vnet_subnet_id               = optional(string)
      only_critical_addons_enabled = optional(bool)
      zones                        = optional(list(string))
    })

    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
      }), {
      type = "SystemAssigned"
    })

    network_profile = optional(object({
      network_plugin    = string
      network_policy    = optional(string)
      dns_service_ip    = optional(string)
      service_cidr      = optional(string)
      load_balancer_sku = optional(string, "standard")
    }))

    role_based_access_control_enabled = optional(bool, true)

    tags = optional(map(string), {})
  }))
  default = {}
}
