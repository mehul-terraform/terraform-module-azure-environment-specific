resource "azurerm_cdn_frontdoor_profile" "frontdoor_profile" {
  for_each            = var.front_doors
  name                = each.value.front_door_name
  resource_group_name = var.resource_group_name
  sku_name            = each.value.front_door_sku_name

  tags = merge(var.tags, try(each.value.tags, {}))
}

resource "azurerm_cdn_frontdoor_endpoint" "endpoint_frontend" {
  for_each                 = var.front_doors
  name                     = each.value.endpoint_frontend_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.frontdoor_profile[each.key].id

  tags = merge(var.tags, try(each.value.tags, {}))
}

resource "azurerm_cdn_frontdoor_endpoint" "endpoint_backend" {
  for_each                 = var.front_doors
  name                     = each.value.endpoint_backend_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.frontdoor_profile[each.key].id

  tags = merge(var.tags, try(each.value.tags, {}))
}

resource "azurerm_cdn_frontdoor_origin_group" "origin_group_frontend" {
  for_each                 = var.front_doors
  name                     = each.value.origin_group_frontend_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.frontdoor_profile[each.key].id
  session_affinity_enabled = false

  load_balancing {
    sample_size                        = 4
    successful_samples_required        = 3
    additional_latency_in_milliseconds = 50
  }

  health_probe {
    path                = "/"
    request_type        = "GET"
    protocol            = "Https"
    interval_in_seconds = 100
  }
}

resource "azurerm_cdn_frontdoor_origin" "origin_frontend" {
  for_each                       = var.front_doors
  name                           = each.value.origin_frontend_name
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.origin_group_frontend[each.key].id
  host_name                      = each.value.origin_host_frontend_name
  origin_host_header             = each.value.origin_host_frontend_name
  http_port                      = 80
  https_port                     = 443
  weight                         = 1000
  certificate_name_check_enabled = true
  enabled                        = true
}

resource "azurerm_cdn_frontdoor_origin_group" "origin_group_backend" {
  for_each                 = var.front_doors
  name                     = each.value.origin_group_backend_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.frontdoor_profile[each.key].id
  session_affinity_enabled = false

  load_balancing {
    sample_size                        = 4
    successful_samples_required        = 3
    additional_latency_in_milliseconds = 50
  }

  health_probe {
    path                = "/"
    request_type        = "GET"
    protocol            = "Https"
    interval_in_seconds = 100
  }
}

resource "azurerm_cdn_frontdoor_origin" "origin_backend" {
  for_each                       = var.front_doors
  name                           = each.value.origin_backend_name
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.origin_group_backend[each.key].id
  host_name                      = each.value.origin_host_backend_name
  origin_host_header             = each.value.origin_host_backend_name
  http_port                      = 80
  https_port                     = 443
  weight                         = 1000
  certificate_name_check_enabled = true
  enabled                        = true
}

resource "azurerm_cdn_frontdoor_custom_domain" "custome_domain_frontend" {
  for_each                 = var.front_doors
  name                     = each.value.custome_domain_frontend_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.frontdoor_profile[each.key].id
  host_name                = each.value.host_custome_domain_frontend_name

  tls {
    certificate_type = "ManagedCertificate"
  }
}

resource "azurerm_cdn_frontdoor_custom_domain" "custome_domain_backend" {
  for_each                 = var.front_doors
  name                     = each.value.custome_domain_backend_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.frontdoor_profile[each.key].id
  host_name                = each.value.host_custome_domain_backend_name

  tls {
    certificate_type = "ManagedCertificate"
  }
}

resource "azurerm_cdn_frontdoor_route" "route_frontend" {
  for_each                        = var.front_doors
  name                            = each.value.route_frontend_name
  cdn_frontdoor_endpoint_id       = azurerm_cdn_frontdoor_endpoint.endpoint_frontend[each.key].id
  cdn_frontdoor_origin_group_id   = azurerm_cdn_frontdoor_origin_group.origin_group_frontend[each.key].id
  cdn_frontdoor_origin_ids        = [azurerm_cdn_frontdoor_origin.origin_frontend[each.key].id]
  cdn_frontdoor_custom_domain_ids = [azurerm_cdn_frontdoor_custom_domain.custome_domain_frontend[each.key].id]

  supported_protocols    = ["Http", "Https"]
  patterns_to_match      = ["/*"]
  forwarding_protocol    = "MatchRequest"
  https_redirect_enabled = true
  link_to_default_domain = true
  enabled                = true
}

resource "azurerm_cdn_frontdoor_route" "route_backend" {
  for_each                        = var.front_doors
  name                            = each.value.route_backend_name
  cdn_frontdoor_endpoint_id       = azurerm_cdn_frontdoor_endpoint.endpoint_backend[each.key].id
  cdn_frontdoor_origin_group_id   = azurerm_cdn_frontdoor_origin_group.origin_group_backend[each.key].id
  cdn_frontdoor_origin_ids        = [azurerm_cdn_frontdoor_origin.origin_backend[each.key].id]
  cdn_frontdoor_custom_domain_ids = [azurerm_cdn_frontdoor_custom_domain.custome_domain_backend[each.key].id]

  supported_protocols    = ["Http", "Https"]
  patterns_to_match      = ["/*"]
  forwarding_protocol    = "MatchRequest"
  https_redirect_enabled = true
  link_to_default_domain = true
  enabled                = true
}

# Creating Web Application Firewall Security Policy for Frontdoor (All Domains)
resource "azurerm_cdn_frontdoor_security_policy" "security_policy" {
  for_each = {
    for k, v in var.front_doors : k => v
    if try(v.enable_waf, false) == true
  }

  name                     = "${each.value.front_door_name}-sec-pol"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.frontdoor_profile[each.key].id

  security_policies {
    firewall {
      cdn_frontdoor_firewall_policy_id = each.value.waf_policy_link_id

      association {
        domain {
          cdn_frontdoor_domain_id = azurerm_cdn_frontdoor_custom_domain.custome_domain_frontend[each.key].id
        }
        domain {
          cdn_frontdoor_domain_id = azurerm_cdn_frontdoor_custom_domain.custome_domain_backend[each.key].id
        }
        patterns_to_match = ["/*"]
      }
    }
  }
}

