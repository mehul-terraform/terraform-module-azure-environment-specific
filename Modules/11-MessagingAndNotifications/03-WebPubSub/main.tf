resource "azurerm_web_pubsub" "this" {
  for_each            = var.web_pubsubs
  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku      = lookup(each.value, "sku", "Free_F1")
  capacity = lookup(each.value, "capacity", 1)

  public_network_access_enabled = lookup(each.value, "public_network_access_enabled", true)
  local_auth_enabled            = lookup(each.value, "local_auth_enabled", true)
  aad_auth_enabled              = lookup(each.value, "aad_auth_enabled", true)
  tls_client_cert_enabled       = lookup(each.value, "tls_client_cert_enabled", false)

  tags = merge(var.tags, lookup(each.value, "tags", {}))
}
