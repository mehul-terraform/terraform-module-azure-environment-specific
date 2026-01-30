output "notification_hub_namespace_ids" {
  description = "The IDs of the Notification Hub Namespaces"
  value       = { for k, v in azurerm_notification_hub_namespace.namespace : k => v.id }
}

output "notification_hub_ids" {
  description = "The IDs of the Notification Hubs"
  value       = { for k, v in azurerm_notification_hub.hub : k => v.id }
}
