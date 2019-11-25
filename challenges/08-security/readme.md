# Challenge 08 - Creating an Azure Virtual Machine with secured passwords

In this section you will extend the VM created in Challenge 2 with secured passwords, therefore you will have to:

- Create secret in an existing Key Vault
- Reference secret in your VM configuration

## Overview

In any real world Infrastructure as Code project, you will have secrets such as tokens, passwords, connection strings, certificates, encryption keys, etc. that are required in order to provision the desired resources. Although these are required by the code, you should NOT include the actual secret in the code. There are a number of ways to reference secrets from code of varying ease of use and security. In this lab, we will be using a central store, [Azure Key Vault](https://azure.microsoft.com/en-us/services/key-vault/?&ef_id=EAIaIQobChMIocnT3-Cj5QIVbx6tBh16xwXkEAAYASAAEgI-jfD_BwE:G:s&OCID=AID2000128_SEM_IMHcwqu6&MarinID=IMHcwqu6_359393301283_azure%20key%20vault_e_c__73271632300_kwd-415940116485&lnkd=Google_Azure_Brand&gclid=EAIaIQobChMIocnT3-Cj5QIVbx6tBh16xwXkEAAYASAAEgI-jfD_BwE), to store, manage and reference your secrets.

This lab you will create an Azure Key Vault, create a ransom password and store it as a secret. In a second step you will create a VM that is referencing this password.

## Part 1 - Store Secret in Azure Key Vault

In order to create the secret in a secure manner, you will be introduced to the concept of using multiple Terraform providers in a single configuration. You will add the following providers to our configuration:
 - [Random Provider](https://www.terraform.io/docs/providers/random/index.html)

### Setup

From the Cloud Shell, change directory into a folder specific to this challenge. If you created the scaffolding in Challenge 00, then then you can use the command cd ~/AzureWorkChallenges/challenge08/.

Copy the all `*.tf` files from challenge 02 into the current directory.

Be sure to update the value of the `name` variable in `variables.tf`:

```hcl
variable "name" {
  default = "challenge08"
}
```

#### CHEAT SHEET

<details>
<summary>
Expand for full variables.tf code
</summary>

```terraform
variable "name" {
  default = "challenge08"
}

variable "location" {
  default = "centralus"
}
```
</details>

### Configuration

In order to reference logged in user credentiasl in terraform we need to introduce a data provider in your `main.tf` file: 

```Terraform
data "azurerm_client_config" "current" {}
```

Now create a random provider in `main.tf` to generate a random password used in key_vault later:

```Terraform
resource "random_password" "admin_pwd" {
  length  = 24
  special = true
}
```

    > **NOTE**: You are using the `random_password` instead of the `random_string` resource to ensure that the generated password is not output in clear text to logs, etc. It will still be stored in the state file which is why it is critical to properly secure your terraform state. 

In the next step we need to create a Azure Key Vault and assign a secret to it. Manipulating secrets in Azure Key Vault require an access policy which we will create with the credentials collected from the data provider defined above. Add following code to your `main.tf` file:

```Terraform
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
```

Last but not least, we need to reference the Azure Key Vault Secret in our VM creation code, please replace the following line in your `main.tf` file:

```Terraform
    admin_password = "Password1234!"
}
```
with:
```Terraform
    admin_password = azurerm_key_vault_secret.main.value
}
```

#### CHEAT SHEET
<details>
<summary>
Expand for full main.tf code
</summary>

```terraform
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
```

</details>


### Providers 

The 3th and final file that we need to update for this part of the challenge is the providers.tf file. As you have seen in previous labs, you will utilize the [providers block](https://www.terraform.io/docs/configuration/providers.html) to set the version of the providers that are required for this configuration. Add a block for the following providers that are used in the config:
- `random` greater than or equal to version 2.2.0

#### CHEAT SHEET

<details>
<summary>
Expand for full providers.tf code
</summary>

```terraform
provider "azurerm" {
  version = ">= 1.36"
}

terraform {
  required_version = ">= 0.12.12"
}

provider "random" {
  version = ">=2.2.0"
}
```
</details>

### Apply the configuration

With the Terrform configuration complete, all that is left to do is to validate that everything is correct, validate that it is going to do what you expect and apply it. As you have learned in previous challenges execute the following steps:
- Initiallize the working directory
- Create the execution plan
- Apply the changes

#### CHEAT SHEET

<details>
<summary>
Expand for exact commands to run
</summary>

```bash
terraform init
...
terraform plan -out tfplan
...
terraform apply tfplan
...
```
</details>

### Verification

Assuming that the configuration completed successfully, you can validate that everything really did do as you expect by browsing to the resource group where you provisioned the resources, then select the Key Vault instance and ensure that the "vm-secret" secret has been created.

    > **NOTE**: You might not be able to see your secret since your logged in user in the portal might no have rights to see them. In that case you will need to add manually and access_policy over the portal.

