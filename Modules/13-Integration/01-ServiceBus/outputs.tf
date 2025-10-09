output "namespace_id" {
  value = azurerm_servicebus_namespace.this.id
}

output "topic_id" {
  value = azurerm_servicebus_topic.this.id
}

output "queue_id" {
  value = azurerm_servicebus_queue.this.id
}
