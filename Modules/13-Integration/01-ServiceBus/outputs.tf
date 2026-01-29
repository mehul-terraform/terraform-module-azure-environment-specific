output "namespace_ids" {
  value = { for k, v in azurerm_servicebus_namespace.this : k => v.id }
}

output "topic_ids" {
  value = { for k, v in azurerm_servicebus_topic.this : k => v.id }
}

output "queue_ids" {
  value = { for k, v in azurerm_servicebus_queue.this : k => v.id }
}
