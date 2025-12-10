resource "azurerm_static_web_app" "static_webapp" {
  name                = var.static_webapp_name
  resource_group_name = var.resource_group_name
  location            = var.static_webapp_location
  repository_url      = var.repository_url
  repository_branch   = var.repository_branch
  repository_token    = var.repository_token

  sku_tier = var.sku_tier
  sku_size = var.sku_size

  lifecycle {
    ignore_changes = [
      repository_url,
      repository_branch,
      tags
    ]
  }

  dynamic "identity" {
    for_each = var.sku_tier != "Free" ? [1] : []
    content {
      type = "SystemAssigned"
    }
  }
}
