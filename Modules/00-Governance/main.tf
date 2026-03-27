resource "azurerm_subscription_policy_assignment" "allowed_locations" {
  count                = var.allowed_locations != null ? 1 : 0
  name                 = "allowed-locations"
  subscription_id      = var.subscription_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975a4c"
  display_name         = "Allowed locations"
  description          = "This policy enables you to restrict the locations your organization can specify when deploying resources."

  parameters = jsonencode({
    listOfAllowedLocations = {
      value = var.allowed_locations
    }
  })
}

resource "azurerm_subscription_policy_assignment" "required_tags" {
  for_each             = var.required_tags
  name                 = "require-tag-${each.key}"
  subscription_id      = var.subscription_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/1e30110a-5ceb-460c-828b-107e49ff3615"
  display_name         = "Require ${each.key} tag on resources"
  description          = "Enforces existence of a tag on resources."

  parameters = jsonencode({
    tagName = {
      value = each.key
    }
  })
}

resource "azurerm_subscription_policy_assignment" "inherit_tags" {
  name                 = "inherit-tags-from-rg"
  subscription_id      = var.subscription_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/445205e4-75eb-49c8-bc51-219dd7e2c93f"
  display_name         = "Inherit a tag from the resource group"
  description          = "Adds or replaces the specified tag and value from the parent resource group when a resource is created or updated."

  parameters = jsonencode({
    tagName = {
      value = "Environment"
    }
  })
}
