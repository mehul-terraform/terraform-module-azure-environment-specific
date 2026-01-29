resource "azurerm_servicebus_namespace" "this" {
  for_each            = var.service_buses
  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = lookup(each.value, "sku", "Standard")
  capacity            = lookup(each.value, "capacity", null)
  tags                = merge(var.tags, lookup(each.value, "tags", {}))
}

resource "azurerm_servicebus_topic" "this" {
  for_each     = var.service_buses
  name         = each.value.topic_name
  namespace_id = azurerm_servicebus_namespace.this[each.key].id
}

resource "azurerm_servicebus_queue" "this" {
  for_each     = var.service_buses
  name         = each.value.queue_name
  namespace_id = azurerm_servicebus_namespace.this[each.key].id

}

# Optional: Authorization Rule
resource "azurerm_servicebus_topic_authorization_rule" "this" {
  for_each = var.service_buses
  name     = "auth-rule"
  topic_id = azurerm_servicebus_topic.this[each.key].id

  listen = true
  send   = true
  manage = false
}


