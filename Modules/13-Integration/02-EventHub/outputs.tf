output "eventhub_namespace_ids" {
  description = "The IDs of the EventHub Namespaces"
  value       = { for k, v in azurerm_eventhub_namespace.namespace : k => v.id }
}

output "eventhub_ids" {
  description = "The IDs of the EventHubs"
  value       = { for k, v in azurerm_eventhub.eventhub : k => v.id }
}
