resource "azurerm_communication_service" "communication" {
  name                = var.communication_service_name
  resource_group_name = var.resource_group_name
    tags                = var.tags
}

resource "azurerm_email_communication_service" "email" {
  name                = var.email_service_name
  resource_group_name = var.resource_group_name
  data_location       = var.data_location
  tags                = var.tags
}

resource "azurerm_email_communication_service_domain" "custom_domain" {
  name                             = var.domain_name
  email_service_id                 = azurerm_email_communication_service.email.id
  domain_management                = "CustomerManaged"
  user_engagement_tracking_enabled = var.enable_user_engagement_tracking
  tags                = var.tags
}