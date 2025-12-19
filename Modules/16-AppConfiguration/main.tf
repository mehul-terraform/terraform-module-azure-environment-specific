resource "azurerm_app_configuration" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "standard"

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

resource "azurerm_app_configuration_key" "keys" {
  for_each = var.key_values

  configuration_store_id = azurerm_app_configuration.this.id
  key                    = each.key
  value                  = each.value.value
  label                  = lookup(each.value, "label", null)
}