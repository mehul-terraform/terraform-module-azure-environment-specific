resource "azurerm_servicebus_namespace" "this" {
  name                = var.namespace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  capacity            = var.capacity
  tags                = var.tags
}

resource "azurerm_servicebus_topic" "this" {
  name         = var.topic_name
  namespace_id = azurerm_servicebus_namespace.this.id
}

resource "azurerm_servicebus_queue" "this" {
  name         = var.queue_name
  namespace_id = azurerm_servicebus_namespace.this.id

}

# Optional: Authorization Rule
resource "azurerm_servicebus_topic_authorization_rule" "this" {
  name     = "auth-rule"
  topic_id = azurerm_servicebus_topic.this.id

  listen = true
  send   = true
  manage = false
}


