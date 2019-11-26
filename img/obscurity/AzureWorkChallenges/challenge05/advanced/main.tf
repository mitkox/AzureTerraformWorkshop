module "network" {
  source              = "Azure/network/azurerm"
  version             = "2.0.0"
  resource_group_name = "myapp-networking"
  location            = "centralus"

  tags = {
    environment = "dev"
  }
}

module "windowsservers" {
  source              = "Azure/compute/azurerm"
  version             = "1.3.0"
  resource_group_name = "myapp-compute-windows"
  location            = "centralus"
  admin_password      = "ComplxP@ssw0rd!"
  vm_os_simple        = "WindowsServer"
  public_ip_dns       = ["zenoonlyonewin23"]
  vnet_subnet_id      = "${module.network.vnet_subnets[0]}"
}

module "linuxservers" {
  source              = "Azure/compute/azurerm"
  version             = "1.3.0"
  resource_group_name = "myapp-compute-linux"
  location            = "centralus"
  admin_password      = "ComplxP@ssw0rd!"
  vm_os_simple        = "UbuntuServer"
  nb_public_ip        = 0
  vnet_subnet_id      = "${module.network.vnet_subnets[0]}"
}

  output "windows_vm_public_name"{
    value = "${module.windowsservers.public_ip_dns_name}"
  }