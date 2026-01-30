resource "azurerm_communication_service" "communication" {
  for_each = var.communication_services

  name                = each.value.communication_service_name
  resource_group_name = var.resource_group_name
  data_location       = each.value.data_location
  tags                = merge(var.tags, lookup(each.value, "tags", {}))
}

resource "azurerm_email_communication_service" "email" {
  for_each = var.communication_services

  name                = each.value.email_service_name
  resource_group_name = var.resource_group_name
  data_location       = each.value.data_location
  tags                = merge(var.tags, lookup(each.value, "tags", {}))
}

resource "azurerm_email_communication_service_domain" "custom_domain" {
  for_each = var.communication_services

  name                             = each.value.domain_name
  email_service_id                 = azurerm_email_communication_service.email[each.key].id
  domain_management                = "CustomerManaged"
  user_engagement_tracking_enabled = lookup(each.value, "enable_user_engagement_tracking", false)
  tags                             = merge(var.tags, lookup(each.value, "tags", {}))
}
