output "network_interface_ids" {
  value = { for k, v in azurerm_network_interface.network_interface : k => v.id }
}

output "virtual_machine_ids" {
  value = { for k, v in azurerm_windows_virtual_machine.virtual_machine : k => v.id }
}

output "public_ip_addresses" {
  value = { for k, v in azurerm_public_ip.public_ip : k => v.ip_address }
}

output "admin_passwords" {
  description = "Admin passwords stored in Key Vault"
  value       = { for k, v in random_password.admin : k => v.result }
  sensitive   = true
}
