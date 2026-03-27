output "policy_assignment_ids" {
  description = "The IDs of the policy assignments."
  value = {
    allowed_locations = length(azurerm_subscription_policy_assignment.allowed_locations) > 0 ? azurerm_subscription_policy_assignment.allowed_locations[0].id : null
    required_tags     = { for k, v in azurerm_subscription_policy_assignment.required_tags : k => v.id }
    inherit_tags      = azurerm_subscription_policy_assignment.inherit_tags.id
  }
}
