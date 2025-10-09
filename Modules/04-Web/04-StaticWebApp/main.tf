resource "azurerm_static_web_app" "static_webapp" {
  name                = var.static_webapp_name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku_tier = var.sku_tier
  sku_size = var.sku_size

  dynamic "identity" {
    for_each = var.sku_tier != "Free" ? [1] : []
    content {
      type = "SystemAssigned"
    }
  }
}
