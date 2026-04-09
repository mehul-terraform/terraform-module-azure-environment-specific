terraform {
  backend "azurerm" {
    resource_group_name  = "myexample-tf-rg" # Update if needed
    storage_account_name = "myexampletfstorage" # Update if needed
    container_name       = "myexample-uat-tfstate"
    key                  = "terraform.tfstate"
  }
}
