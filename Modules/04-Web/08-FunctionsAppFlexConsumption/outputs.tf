output "function_app_ids" {
  value = {
    for k, v in azurerm_function_app_flex_consumption.this :
    k => v.id
  }
}


