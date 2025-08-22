resource "azurerm_service_plan" "asp" {

  name                = var.service_plan_name
  location            = var.location
  os_type             = var.asp_os_type
  resource_group_name = var.resource_group_name
  sku_name            = var.asp_sku_name
  tags                = merge(var.tags) 

  per_site_scaling_enabled = var.per_site_scaling_enabled
  worker_count             = var.worker_count
}