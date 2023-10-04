terraform {
  required_version = ">= 1.3.0"
  backend "azurerm" {
    resource_group_name   = "tstate"
    storage_account_name  = "tstate9616"
    container_name        = "tstate"
    key                   = "terraform.tfstate"
  backend "azurerm" {
    resource_group_name  = "StorageAccount-ResourceGroup"
    storage_account_name = "abcd1234"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }    
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.75.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "challenge07" {
  name     = "challenge07"
  location = "centralus"
}