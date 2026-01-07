locals {
  tags = {
    environment = "development"
    project     = "myexample"
  }
  extra_tags = {
    owner = "myexample"
  }
}

locals {
  postgres_kv_secrets = {
    for k, v in module.postgres_sql_flexible.admin_passwords :
    "${k}-postgres-admin-password" => v.value
  }
}


