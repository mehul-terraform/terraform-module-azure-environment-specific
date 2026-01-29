resource "azurerm_app_configuration" "this" {
  for_each            = var.app_configurations
  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "standard"

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

locals {
  # Flatten keys from all app configurations
  app_keys = flatten([
    for app_k, app_v in var.app_configurations : [
      for key_k, key_v in lookup(app_v, "key_values", {}) : {
        app_config_key = app_k
        key_key        = key_k
        value          = key_v.value
        label          = lookup(key_v, "label", null)
      }
    ]
  ])
}

resource "azurerm_app_configuration_key" "keys" {
  for_each = {
    for item in local.app_keys : "${item.app_config_key}-${item.key_key}" => item
  }

  configuration_store_id = azurerm_app_configuration.this[each.value.app_config_key].id
  key                    = each.value.key_key
  value                  = each.value.value
  label                  = each.value.label
}
