terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.92.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "DoNotDeleteBackend"
    storage_account_name = "donotdeletebackendsa"
    container_name       = "statefile"
    key                  = "DevInfra.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}