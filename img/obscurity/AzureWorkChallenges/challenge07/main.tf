terraform {
  backend "azurerm" {
    resource_group_name   = "tstate"
    storage_account_name  = "tstate8635"
    container_name        = "tstate"
    key                   = "terraform.tfstate"
  }
}

resource "azurerm_resource_group" "challenge07" {
  name     = "challenge07"
  location = "centralus"
}