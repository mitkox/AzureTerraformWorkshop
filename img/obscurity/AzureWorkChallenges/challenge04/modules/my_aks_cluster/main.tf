resource "azurerm_resource_group" "rg" {
  name     = "${var.name}-rg"
  location = var.location
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "var.aks_name${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "dnsname"
  count               = var.clustercount

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.vm_size
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

resource "random_string" "storage-name" {
  length  = 12
  upper   = false
  numeric  = false
  lower   = true
  special = false
}

resource "azurerm_storage_account" "storageacount" {
  name                     = "${random_string.storage-name.result}sta${count.index}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  count                    = var.clustercount

  tags = {
    environment = "staging"
  }
}