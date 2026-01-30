output "virtual_machine_ids" {
  description = "The IDs of the Virtual Machines."
  value       = { for k, v in azurerm_linux_virtual_machine.virtual_machine : k => v.id }
}

output "network_interface_ids" {
  description = "The IDs of the Network Interfaces."
  value       = { for k, v in azurerm_network_interface.network_interface : k => v.id }
}

output "public_ip_ids" {
  description = "The IDs of the Public IPs."
  value       = { for k, v in azurerm_public_ip.public_ip : k => v.id }
}

output "admin_passwords" {
  description = "The admin passwords."
  value       = { for k, v in random_password.admin : k => v.result }
  sensitive   = true
}
