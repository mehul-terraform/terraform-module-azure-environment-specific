output "ids" {
  description = "The IDs of the WAF Policies"
  value       = { for k, v in azurerm_cdn_frontdoor_firewall_policy.waf_policy : k => v.id }
}

output "names" {
  description = "The names of the WAF Policies"
  value       = { for k, v in azurerm_cdn_frontdoor_firewall_policy.waf_policy : k => v.name }
}
