resource "azurerm_cdn_frontdoor_profile" "frontdoor_profile" {
  name                = var.front_door_name
  resource_group_name = var.resource_group_name
  sku_name            = var.front_door_sku_name

  tags = merge(var.tags)
}

resource "azurerm_cdn_frontdoor_endpoint" "endpoint_frontend" {
  name                     = var.endpoint_frontend_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.frontdoor_profile.id

  tags = merge(var.tags)
}

resource "azurerm_cdn_frontdoor_endpoint" "endpoint_backend" {
  name                     = var.endpoint_backend_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.frontdoor_profile.id

  tags = merge(var.tags)
}

resource "azurerm_cdn_frontdoor_origin_group" "origin_group_frontend" {
  name                     = var.origin_group_frontend_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.frontdoor_profile.id
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
  name                           = var.origin_frontend_name
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.origin_group_frontend.id
  host_name                      = var.origin_host_frontend_name
  origin_host_header             = var.origin_host_frontend_name
  http_port                      = 80
  https_port                     = 443
  weight                         = 1000
  certificate_name_check_enabled = true
  enabled                        = true
}

resource "azurerm_cdn_frontdoor_origin_group" "origin_group_backend" {
  name                     = var.origin_group_backend_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.frontdoor_profile.id
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
  name                           = var.origin_backend_name
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.origin_group_backend.id
  host_name                      = var.origin_host_backend_name
  origin_host_header             = var.origin_host_backend_name
  http_port                      = 80
  https_port                     = 443
  weight                         = 1000
  certificate_name_check_enabled = true
  enabled                        = true
}

resource "azurerm_cdn_frontdoor_custom_domain" "custome_domain_frontend" {
  name                     = var.custome_domain_frontend_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.frontdoor_profile.id
  host_name                = var.host_custome_domain_frontend_name

  tls {
    certificate_type = "ManagedCertificate"
  }
}

resource "azurerm_cdn_frontdoor_custom_domain" "custome_domain_backend" {
  name                     = var.custome_domain_backend_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.frontdoor_profile.id
  host_name                = var.host_custome_domain_backend_name

  tls {
    certificate_type = "ManagedCertificate"
  }
}

resource "azurerm_cdn_frontdoor_route" "route_frontend" {
  name                            = var.route_frontend_name
  cdn_frontdoor_endpoint_id       = azurerm_cdn_frontdoor_endpoint.endpoint_frontend.id
  cdn_frontdoor_origin_group_id   = azurerm_cdn_frontdoor_origin_group.origin_group_frontend.id
  cdn_frontdoor_origin_ids        = [azurerm_cdn_frontdoor_origin.origin_frontend.id]
  cdn_frontdoor_custom_domain_ids = [azurerm_cdn_frontdoor_custom_domain.custome_domain_frontend.id]

  supported_protocols    = ["Http", "Https"]
  patterns_to_match      = ["/*"]
  forwarding_protocol    = "MatchRequest"
  https_redirect_enabled = true
  link_to_default_domain = true
  enabled                = true
}

resource "azurerm_cdn_frontdoor_route" "route_backend" {
  name                            = var.route_backend_name
  cdn_frontdoor_endpoint_id       = azurerm_cdn_frontdoor_endpoint.endpoint_backend.id
  cdn_frontdoor_origin_group_id   = azurerm_cdn_frontdoor_origin_group.origin_group_backend.id
  cdn_frontdoor_origin_ids        = [azurerm_cdn_frontdoor_origin.origin_backend.id]
  cdn_frontdoor_custom_domain_ids = [azurerm_cdn_frontdoor_custom_domain.custome_domain_backend.id]

  supported_protocols    = ["Http", "Https"]
  patterns_to_match      = ["/*"]
  forwarding_protocol    = "MatchRequest"
  https_redirect_enabled = true
  link_to_default_domain = true
  enabled                = true
}

/**  
# Creating Web Application Firewall policy for Frontdoor
resource "azurerm_cdn_frontdoor_security_policy" "example" {
  name                     = "${var.front_door_name}-security-policy"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.frontdoor_profile.id
 
  security_policies {
    firewall {
      cdn_frontdoor_firewall_policy_id = var.waf_policy_link_id
 
 
      association {
        domain {
          cdn_frontdoor_domain_id = azurerm_cdn_frontdoor_custom_domain.frontend_domain.id
        }
        patterns_to_match = ["/*"]
      }
    }
  }
}
**/
