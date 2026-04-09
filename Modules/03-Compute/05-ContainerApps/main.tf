resource "azurerm_container_app_environment" "env" {
  for_each = var.container_app_environments

  name                       = each.value.name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "workload_profile" {
    for_each = lookup(each.value, "workload_profiles", [])
    content {
      name                  = workload_profile.value.name
      workload_profile_type = workload_profile.value.workload_profile_type
      maximum_count         = lookup(workload_profile.value, "maximum_count", null)
      minimum_count         = lookup(workload_profile.value, "minimum_count", null)
    }
  }

  tags = merge(var.tags, lookup(each.value, "tags", {}))
}

resource "azurerm_container_app" "app" {
  for_each = var.container_apps

  name                         = each.value.name
  container_app_environment_id = azurerm_container_app_environment.env[each.value.environment_key].id
  resource_group_name          = var.resource_group_name
  revision_mode                = lookup(each.value, "revision_mode", "Single")

  template {
    dynamic "container" {
      for_each = each.value.containers
      content {
        name   = container.value.name
        image  = container.value.image
        cpu    = container.value.cpu
        memory = container.value.memory

        dynamic "env" {
          for_each = lookup(container.value, "env", [])
          content {
            name        = env.value.name
            value       = env.value.value
            secret_name = env.value.secret_name
          }
        }
      }
    }
  }

  dynamic "identity" {
    for_each = lookup(each.value, "identity", null) != null ? [each.value.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "ingress" {
    for_each = lookup(each.value, "ingress", null) != null ? [each.value.ingress] : []
    content {
      allow_insecure_connections = lookup(ingress.value, "allow_insecure_connections", false)
      external_enabled           = lookup(ingress.value, "external_enabled", false)
      target_port                = ingress.value.target_port
      transport                  = lookup(ingress.value, "transport", "auto")

      dynamic "traffic_weight" {
        for_each = lookup(ingress.value, "traffic_weight", [])
        content {
          latest_revision = lookup(traffic_weight.value, "latest_revision", true)
          percentage      = traffic_weight.value.percentage
          label           = lookup(traffic_weight.value, "label", null)
        }
      }
    }
  }

  tags = merge(var.tags, lookup(each.value, "tags", {}))
}
