output "virtual_network_id" {
  value = azurerm_virtual_network.virtual_network.id
}

output "subnet_ids" {
  value = {
    for k, s in azurerm_subnet.subnets : k => s.id
  }
}

output "vm_subnets" {
  value = {
    vm = azurerm_subnet.subnets["vm"].id
  }
}

output "db_subnets" {
  value = {
    db = azurerm_subnet.subnets["db"].id
  }
}
