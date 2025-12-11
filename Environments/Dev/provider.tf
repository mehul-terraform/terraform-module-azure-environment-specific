# 00-Provider

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  #subscription_id = "339e9158-9454-4c79-a362-c37d1f2469a2"  
  subscription_id = "c09e0f60-cb15-4c23-8500-eeae1ec9dd6b"
  tenant_id       = "8fc36c8e-1077-4442-a9a3-ef873f9cc6c7"

 

  #client_id       = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
  #client_secret   = "ABABBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"

  disable_correlation_request_id = true
  disable_terraform_partner_id   = true
  #skip_provider_registration = true
  #  subscription_id = "c09e0f60-cb15-4c23-8500-eeae1ec9dd6b" # "az account show --query id -o tsv"
}
