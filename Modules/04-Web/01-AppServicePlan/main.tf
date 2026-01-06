resource "azurerm_service_plan" "asp" {
  for_each = var.service_plans

  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name

  os_type   = each.value.os_type
  sku_name = each.value.sku_name

  per_site_scaling_enabled = each.value.per_site_scaling_enabled
  worker_count             = each.value.worker_count

  tags = merge(var.tags, each.value.tags)
}
