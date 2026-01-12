output "topic_ids" {
  value = {
    for k, v in azurerm_eventgrid_topic.this :
    k => v.id
  }
}

output "topic_endpoints" {
  value = {
    for k, v in azurerm_eventgrid_topic.this :
    k => v.endpoint
  }
}
