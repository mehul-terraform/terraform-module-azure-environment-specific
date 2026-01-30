resource "azurerm_eventhub_namespace" "namespace" {
  for_each            = var.eventhub_namespaces
  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = each.value.sku
  capacity            = each.value.capacity

  auto_inflate_enabled     = each.value.auto_inflate_enabled
  maximum_throughput_units = each.value.auto_inflate_enabled ? each.value.maximum_throughput_units : 0
  # zone_redundant           = each.value.zone_redundant

  tags = merge(var.tags, try(each.value.tags, {}))
}

resource "azurerm_eventhub" "eventhub" {
  for_each = {
    for pair in flatten([
      for ns_key, ns in var.eventhub_namespaces : [
        for eh_name, eh in try(ns.eventhubs, {}) : {
          ns_key            = ns_key
          eh_name           = eh_name
          name              = eh.name
          partition_count   = eh.partition_count
          message_retention = eh.message_retention
        }
      ]
    ]) : "${pair.ns_key}-${pair.eh_name}" => pair
  }

  name              = each.value.name
  namespace_id      = azurerm_eventhub_namespace.namespace[each.value.ns_key].id
  partition_count   = each.value.partition_count
  message_retention = each.value.message_retention
}
