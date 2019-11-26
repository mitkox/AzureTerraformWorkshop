resource "azurerm_resource_group" "main" {
  name     = "${var.name}-rg"
  location = var.location
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.name}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            =  azurerm_resource_group.main.location
  resource_group_name =  azurerm_resource_group.main.name
}

resource "azurerm_subnet" "main" {
  name                 = "${var.name}-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefix       = "10.0.1.0/24"
}

resource "azurerm_public_ip" "main" {
  name                = "${var.name}-pubip${count.index}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  count = var.vmcount
}

resource "azurerm_lb" "main" {
  name                = "${var.name}-lb${count.index}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  count = var.vmcount


  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.main.id
  }
}

resource "azurerm_network_interface" "main" {
  name                = "${var.name}-nic${count.index}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  count = var.vmcount

  ip_configuration {
    name                          = "config1"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = element(azurerm_public_ip.main.*.id, count.index)
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = "${var.name}-vm${count.index}"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [element(azurerm_network_interface.main.*.id, count.index)]
  vm_size               = "Standard_A2_v2"
  count = var.vmcount

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.name}vm-osdisk${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.name}vm${count.index}"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }

  os_profile_windows_config {}
  tags = {
    advanced = "done"
  }
}