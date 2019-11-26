provider "azurerm" {
  version = ">= 1.36"
}

terraform {
  required_version = ">= 0.12.12"
}

provider "random" {
  version = ">=2.2.0"
}