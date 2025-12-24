output "storage_account_ids" {
  value = {
    for k, sa in azurerm_storage_account.sa :
    k => sa.id
  }
}
