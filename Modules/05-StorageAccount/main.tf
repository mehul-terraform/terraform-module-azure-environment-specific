resource "azurerm_storage_account" "sa" {
  for_each = var.storage_accounts

  name                     = each.value.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type
  tags                     = merge(var.tags, each.value.tags)
}

resource "azurerm_storage_account_static_website" "static_website" {
  for_each = {
    for k, v in var.storage_accounts :
    k => v
    if try(v.static_website, null) != null
  }

  storage_account_id = azurerm_storage_account.sa[each.key].id
  index_document     = each.value.static_website.index_document
  error_404_document = each.value.static_website.error_404_document
}
