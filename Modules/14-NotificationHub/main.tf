resource "azurerm_notification_hub_namespace" "this" {
  name                = var.namespace_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name            = var.namespace_sku
  namespace_type      = "NotificationHub"
}


resource "azurerm_notification_hub" "this" {
  name                = var.notification_hub_name
  resource_group_name = var.resource_group_name
  location            = var.location
  namespace_name      = azurerm_notification_hub_namespace.this.name
}
