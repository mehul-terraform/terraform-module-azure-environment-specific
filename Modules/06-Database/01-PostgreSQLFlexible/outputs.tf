# output "ids" {
#   value = {
#     for k, v in azurerm_postgresql_flexible_server.this :
#     k => {
#       id   = v.id
#       fqdn = v.fqdn
#     }
#   }
# }

output "ids" {
  description = "PostgreSQL server resource IDs"
  value = {
    for k, v in azurerm_postgresql_flexible_server.this :
    k => v.id
  }
}

output "admin_passwords" {
  description = "PostgreSQL admin passwords"
  value = {
    for k, v in random_password.admin :
    k => {
      value = v.result
    }
  }
}

