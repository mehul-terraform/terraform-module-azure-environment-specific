resource "azurerm_cognitive_account" "openai" {
  for_each = var.openai_accounts

  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "OpenAI"
  sku_name            = each.value.sku_name

  public_network_access_enabled = lookup(each.value, "public_network_access_enabled", true)
  custom_subdomain_name         = lookup(each.value, "custom_subdomain_name", lower(each.value.name))

  dynamic "identity" {
    for_each = lookup(each.value, "identity", null) != null ? [each.value.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  tags = merge(var.tags, lookup(each.value, "tags", {}))
}

resource "azurerm_cognitive_deployment" "deployment" {
  for_each = var.openai_deployments

  name                 = each.value.name
  cognitive_account_id = azurerm_cognitive_account.openai[each.value.account_key].id

  model {
    format  = each.value.model.format
    name    = each.value.model.name
    version = each.value.model.version
  }

  sku {
    name     = each.value.sku.name
    capacity = each.value.sku.capacity
  }
}
