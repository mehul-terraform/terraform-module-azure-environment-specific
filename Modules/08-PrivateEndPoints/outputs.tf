output "private_endpoint_ids" {
  value = {
    for k, pe in azurerm_private_endpoint.this : k => pe.id
  }
}

output "private_endpoint_ips" {
  value = {
    for k, pe in azurerm_private_endpoint.this :
    k => pe.private_service_connection[0].private_ip_address
  }
}
