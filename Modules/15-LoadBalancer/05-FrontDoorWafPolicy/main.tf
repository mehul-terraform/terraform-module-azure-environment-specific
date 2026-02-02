resource "azurerm_cdn_frontdoor_firewall_policy" "waf_policy" {
  for_each            = var.waf_policies
  name                = each.value.name
  resource_group_name = var.resource_group_name
  sku_name            = each.value.sku_name
  enabled             = try(each.value.enabled, true)
  mode                = try(each.value.mode, "Prevention")

  tags = merge(var.tags, try(each.value.tags, {}))

  dynamic "custom_rule" {
    for_each = try(each.value.custom_rules, {})
    content {
      name     = custom_rule.value.name
      action   = custom_rule.value.action
      enabled  = try(custom_rule.value.enabled, true)
      priority = custom_rule.value.priority
      type     = custom_rule.value.type

      dynamic "match_condition" {
        for_each = try(custom_rule.value.match_conditions, {})
        content {
          match_variable     = match_condition.value.match_variable
          operator           = match_condition.value.operator
          negation_condition = try(match_condition.value.negation_condition, false)
          match_values       = match_condition.value.match_values
        }
      }
    }
  }

  # Managed rules are only supported with Premium SKU
  dynamic "managed_rule" {
    for_each = each.value.sku_name == "Premium_AzureFrontDoor" ? try(each.value.managed_rules, {}) : {}
    content {
      type    = managed_rule.value.type
      version = managed_rule.value.version
      action  = try(managed_rule.value.action, "Block")

      dynamic "exclusion" {
        for_each = try(managed_rule.value.exclusions, {})
        content {
          match_variable = exclusion.value.match_variable
          operator       = exclusion.value.operator
          selector       = exclusion.value.selector
        }
      }

      dynamic "override" {
        for_each = try(managed_rule.value.overrides, {})
        content {
          rule_group_name = override.value.rule_group_name

          dynamic "rule" {
            for_each = try(override.value.rules, {})
            content {
              rule_id = rule.value.rule_id
              action  = rule.value.action
              enabled = try(rule.value.enabled, true)

              dynamic "exclusion" {
                for_each = try(rule.value.exclusions, {})
                content {
                  match_variable = exclusion.value.match_variable
                  operator       = exclusion.value.operator
                  selector       = exclusion.value.selector
                }
              }
            }
          }
        }
      }
    }
  }
}
