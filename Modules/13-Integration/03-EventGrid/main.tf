resource "azurerm_eventgrid_topic" "this" {
  for_each            = var.eventgrid_topics
  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name

  identity {
    type = lookup(each.value, "identity", false) ? "SystemAssigned" : "None"
  }

  tags = lookup(each.value, "tags", {})
}

resource "azurerm_eventgrid_event_subscription" "this" {
  for_each = var.eventgrid_subscriptions

  name  = each.value.name
  scope = azurerm_eventgrid_topic.this[each.value.topic_key].id

  dynamic "webhook_endpoint" {
    for_each = lookup(each.value, "webhook_endpoint", null) != null ? [1] : []
    content {
      url = each.value.webhook_endpoint
    }
  }

  dynamic "azure_function_endpoint" {
    for_each = lookup(each.value, "azure_function_id", null) != null ? [1] : []
    content {
      function_id = each.value.azure_function_id
    }
  }

  dynamic "storage_queue_endpoint" {
    for_each = lookup(each.value, "storage_queue_endpoint", null) != null ? [1] : []
    content {
      storage_account_id = each.value.storage_queue_endpoint.storage_account_id
      queue_name         = each.value.storage_queue_endpoint.queue_name
    }
  }

  included_event_types = lookup(each.value, "included_event_types", null)

  dynamic "subject_filter" {
    for_each = can(each.value.subject_begins_with) || can(each.value.subject_ends_with) ? [1] : []
    content {
      subject_begins_with = lookup(each.value, "subject_begins_with", null)
      subject_ends_with   = lookup(each.value, "subject_ends_with", null)
    }
  }
}
