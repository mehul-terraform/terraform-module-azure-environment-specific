resource "azurerm_notification_hub_namespace" "namespace" {
  for_each            = var.notification_hub_namespaces
  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name
  namespace_type      = "NotificationHub"
  sku_name            = each.value.sku

  tags = merge(var.tags, try(each.value.tags, {}))
}

resource "azurerm_notification_hub" "hub" {
  for_each = {
    for pair in flatten([
      for ns_key, ns in var.notification_hub_namespaces : [
        for hub_name, hub in try(ns.notification_hubs, {}) : {
          ns_key          = ns_key
          hub_key         = hub_name
          name            = hub.name
          apns_credential = try(hub.apns_credential, null)
          gcm_credential  = try(hub.gcm_credential, null)
        }
      ]
    ]) : "${pair.ns_key}-${pair.hub_key}" => pair
  }

  name                = each.value.name
  namespace_name      = azurerm_notification_hub_namespace.namespace[each.value.ns_key].name
  resource_group_name = var.resource_group_name
  location            = var.location

  dynamic "apns_credential" {
    for_each = each.value.apns_credential != null ? [each.value.apns_credential] : []
    content {
      application_mode = apns_credential.value.application_mode
      bundle_id        = apns_credential.value.bundle_id
      team_id          = apns_credential.value.team_id
      token            = apns_credential.value.token
      key_id           = apns_credential.value.key_id
    }
  }

  dynamic "gcm_credential" {
    for_each = each.value.gcm_credential != null ? [each.value.gcm_credential] : []
    content {
      api_key = gcm_credential.value.api_key
    }
  }

  tags = var.tags
}
