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

  # use_oidc = true

  # disable_correlation_request_id = true
  # disable_terraform_partner_id   = true
}
