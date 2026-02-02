resource "azurerm_static_web_app" "static_webapp" {
  for_each            = var.static_web_apps
  name                = each.value.name
  resource_group_name = var.resource_group_name
  location            = lookup(each.value, "location", "East US 2")
  repository_url      = lookup(each.value, "repository_url", null)
  repository_branch   = lookup(each.value, "repository_branch", "main")
  repository_token    = lookup(each.value, "repository_token", null)

  sku_tier = lookup(each.value, "sku_tier", "Free")
  sku_size = lookup(each.value, "sku_size", "Free")

  lifecycle {
    ignore_changes = [
      repository_url,
      repository_branch,
      tags
    ]
  }

  dynamic "identity" {
    for_each = lookup(each.value, "sku_tier", "Free") != "Free" ? [1] : []
    content {
      type = "SystemAssigned"
    }
  }
}
