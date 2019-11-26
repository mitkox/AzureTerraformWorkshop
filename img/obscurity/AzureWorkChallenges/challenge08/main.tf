data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "main" {
  name     = "${var.name}-rg"
  location = var.location
}

resource "random_password" "admin_pwd" {
  length  = 24
  special = true
}

resource "azurerm_key_vault" "main" {
  name                            = "${var.name}-kv"
  location                        = azurerm_resource_group.main.location
  resource_group_name             = azurerm_resource_group.main.name
  enabled_for_disk_encryption     = true
  enabled_for_deployment          = true
  enabled_for_template_deployment = true
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  sku_name                        = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.service_principal_object_id

    secret_permissions = [
      "list", "get", "delete", "set", "backup", "purge", "recover", "restore",
    ]
  }
  tags = {
    environment = var.name
  }
}

resource "azurerm_key_vault_secret" "main" {
  name         = "vm-secret"
  value        = random_password.admin_pwd.result
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.name}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "main" {
  name                 = "${var.name}-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefix       = "10.0.1.0/24"
}

resource "azurerm_public_ip" "main" {
  name                = "${var.name}-pubip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "main" {
  name                = "${var.name}-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "config1"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = "${var.name}-vm"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_A2_v2"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.name}vm-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.name}vm"
    admin_username = "testadmin"
    admin_password = azurerm_key_vault_secret.main.value
  }

  os_profile_windows_config {}
}