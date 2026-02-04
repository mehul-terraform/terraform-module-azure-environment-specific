output "aks_clusters" {
  value = {
    for key, cluster in azurerm_kubernetes_cluster.aks : key => {
      id                                         = cluster.id
      name                                       = cluster.name
      kube_config_raw                            = cluster.kube_config_raw
      kubelet_identity_object_id                 = try(cluster.kubelet_identity[0].object_id, null)
      kubelet_identity_client_id                 = try(cluster.kubelet_identity[0].client_id, null)
      kubelet_identity_user_assigned_identity_id = try(cluster.kubelet_identity[0].user_assigned_identity_id, null)
      identity_principal_id                      = try(cluster.identity[0].principal_id, null)
      identity_tenant_id                         = try(cluster.identity[0].tenant_id, null)
    }
  }
}
