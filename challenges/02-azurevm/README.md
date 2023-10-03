# Challenge 02 - Creating an AKS Cluster and a Storage account
In this challenge, you will create a AKS cluster and a Storage Account.

You will gradually add Terraform configuration to build all the resources needed to deploy the resources.

The resources you will use in this challenge:

- Resource Group
- Azure Kubernetes Cluster
- Storage Account

## How to

### Create the base Terraform Configuration

We will start with a few of the basic resources needed.

From the Cloud Shell, change directory into a folder specific to this challenge. If you created the scaffolding in Challenge 00, then then you can use the command `cd ~/AzureWorkChallenges/challenge02/`.

Create a `provider.tf` file with the following to pin the version of Terraform and the AzureRM Provider:

```hcl
terraform {
  required_version = ">= 1.3.0"
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
```

### Create Variables

Create a `variables.tf` file  and define a few variables that will help keep our code clean:

```hcl
variable "name" {
  default = "challenge02"
}

variable "location" {
  default = "centralus"
}
```

### Create a Resource Group

Now create a `main.tf` file to create a Resource Group to contain all of our infrastructure using the variables to interpolate the parameters. A variable is a user or machine-supplied input in Terraform configurations. Variables can be supplied via environment variables, CLI flags, or variable files. Combined with modules, variables help make Terraform flexible, sharable, and extensible. Variable must be defined before used, to do so: 


```hcl
resource "azurerm_resource_group" "rg" {
  name     = "${var.name}-rg"
  location = var.location
}
```

### Create AKS Cluster

Create a basic Azure Kubernetes Cluster:

```hcl
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "papcp-aks1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "dnsname"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}
```

> Notice that we use the available metadata from the `azurerm_resource_group.main` resource to populate the parameters of other resources.

### Run Terraform Workflow

Run `terraform init` since this is the first time we are running Terraform from this directory.

Run `terraform plan` where you should see the plan of two new resources, namely the Resource Group and the Virtual Network.

If your plan looks good, go ahead and run `terraform apply` and type "yes" to confirm you want to apply.
When it completes you should see:

```sh
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```

### Create the Storage Account

Storage Account needs to be unique within Azure, often companies use their own naming conventions, in this example we will create a
random name that meets the naming restrictions for Storage Account name:

Create random name:

```hcl
resource "random_string" "storage-name" {
  length  = 12
  upper   = false
  numeric  = false
  lower   = true
  special = false
}
```

Create the Storage Account resource (with the random name generated in previous step):

```hcl
resource "azurerm_storage_account" "storageacount" {
  name                     = "${random_string.storage-name.result}sta"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }
}
```
### Terraform Plan

Running `terraform plan` should contain something like the following:

```sh
challenge02~  tf plan
azurerm_resource_group.rg: Refreshing state... [id=/subscriptions/65ed073b-97bd-4fb8-a098-f1a6aaeb32f9/resourceGroups/challenge02-rg]
azurerm_kubernetes_cluster.aks: Refreshing state... [id=/subscriptions/65ed073b-97bd-4fb8-a098-f1a6aaeb32f9/resourceGroups/challenge02-rg/providers/Microsoft.ContainerService/managedClusters/papcp-aks1]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_storage_account.storageacount will be created
  + resource "azurerm_storage_account" "storageacount" {
      + access_tier                       = (known after apply)
      + account_kind                      = "StorageV2"
      + account_replication_type          = "GRS"
      + account_tier                      = "Standard"
      + allow_nested_items_to_be_public   = true
      + cross_tenant_replication_enabled  = true
      + default_to_oauth_authentication   = false
      + enable_https_traffic_only         = true
      + id                                = (known after apply)
      + infrastructure_encryption_enabled = false
      + is_hns_enabled                    = false
      + large_file_share_enabled          = (known after apply)
      + location                          = "centralus"
      + min_tls_version                   = "TLS1_2"
      + name                              = (known after apply)
      + nfsv3_enabled                     = false
      + primary_access_key                = (sensitive value)
      + primary_blob_connection_string    = (sensitive value)
      + primary_blob_endpoint             = (known after apply)
      + primary_blob_host                 = (known after apply)
      + primary_connection_string         = (sensitive value)
      + primary_dfs_endpoint              = (known after apply)
      + primary_dfs_host                  = (known after apply)
      + primary_file_endpoint             = (known after apply)
      + primary_file_host                 = (known after apply)
      + primary_location                  = (known after apply)
      + primary_queue_endpoint            = (known after apply)
      + primary_queue_host                = (known after apply)
      + primary_table_endpoint            = (known after apply)
      + primary_table_host                = (known after apply)
      + primary_web_endpoint              = (known after apply)
      + primary_web_host                  = (known after apply)
      + public_network_access_enabled     = true
      + queue_encryption_key_type         = "Service"
      + resource_group_name               = "challenge02-rg"
      + secondary_access_key              = (sensitive value)
      + secondary_blob_connection_string  = (sensitive value)
      + secondary_blob_endpoint           = (known after apply)
      + secondary_blob_host               = (known after apply)
      + secondary_connection_string       = (sensitive value)
      + secondary_dfs_endpoint            = (known after apply)
      + secondary_dfs_host                = (known after apply)
      + secondary_file_endpoint           = (known after apply)
      + secondary_file_host               = (known after apply)
      + secondary_location                = (known after apply)
      + secondary_queue_endpoint          = (known after apply)
      + secondary_queue_host              = (known after apply)
      + secondary_table_endpoint          = (known after apply)
      + secondary_table_host              = (known after apply)
      + secondary_web_endpoint            = (known after apply)
      + secondary_web_host                = (known after apply)
      + sftp_enabled                      = false
      + shared_access_key_enabled         = true
      + table_encryption_key_type         = "Service"
      + tags                              = {
          + "environment" = "staging"
        }

      + blob_properties {
          + change_feed_enabled           = (known after apply)
          + change_feed_retention_in_days = (known after apply)
          + default_service_version       = (known after apply)
          + last_access_time_enabled      = (known after apply)
          + versioning_enabled            = (known after apply)

          + container_delete_retention_policy {
              + days = (known after apply)
            }

          + cors_rule {
              + allowed_headers    = (known after apply)
              + allowed_methods    = (known after apply)
              + allowed_origins    = (known after apply)
              + exposed_headers    = (known after apply)
              + max_age_in_seconds = (known after apply)
            }

          + delete_retention_policy {
              + days = (known after apply)
            }

          + restore_policy {
              + days = (known after apply)
            }
        }

      + network_rules {
          + bypass                     = (known after apply)
          + default_action             = (known after apply)
          + ip_rules                   = (known after apply)
          + virtual_network_subnet_ids = (known after apply)

          + private_link_access {
              + endpoint_resource_id = (known after apply)
              + endpoint_tenant_id   = (known after apply)
            }
        }

      + queue_properties {
          + cors_rule {
              + allowed_headers    = (known after apply)
              + allowed_methods    = (known after apply)
              + allowed_origins    = (known after apply)
              + exposed_headers    = (known after apply)
              + max_age_in_seconds = (known after apply)
            }

          + hour_metrics {
              + enabled               = (known after apply)
              + include_apis          = (known after apply)
              + retention_policy_days = (known after apply)
              + version               = (known after apply)
            }

          + logging {
              + delete                = (known after apply)
              + read                  = (known after apply)
              + retention_policy_days = (known after apply)
              + version               = (known after apply)
              + write                 = (known after apply)
            }

          + minute_metrics {
              + enabled               = (known after apply)
              + include_apis          = (known after apply)
              + retention_policy_days = (known after apply)
              + version               = (known after apply)
            }
        }

      + routing {
          + choice                      = (known after apply)
          + publish_internet_endpoints  = (known after apply)
          + publish_microsoft_endpoints = (known after apply)
        }

      + share_properties {
          + cors_rule {
              + allowed_headers    = (known after apply)
              + allowed_methods    = (known after apply)
              + allowed_origins    = (known after apply)
              + exposed_headers    = (known after apply)
              + max_age_in_seconds = (known after apply)
            }

          + retention_policy {
              + days = (known after apply)
            }

          + smb {
              + authentication_types            = (known after apply)
              + channel_encryption_type         = (known after apply)
              + kerberos_ticket_encryption_type = (known after apply)
              + multichannel_enabled            = (known after apply)
              + versions                        = (known after apply)
            }
        }
    }

  # random_string.storage-name will be created
  + resource "random_string" "storage-name" {
      + id          = (known after apply)
      + length      = 12
      + lower       = true
      + min_lower   = 0
      + min_numeric = 0
      + min_special = 0
      + min_upper   = 0
      + number      = false
      + numeric     = false
      + result      = (known after apply)
      + special     = false
      + upper       = false
    }

Plan: 2 to add, 0 to change, 0 to destroy.
```

> Notice that there is a new resource being added and one being updated.

Run `terraform apply` to apply the changes.

### Outputs

You now have all the infrastructure in place and can now connect to the AKS Clyster we just stood up.
But wait, we require a Client Certificate and Kube Config to access it?

You could check the value in the Azure Portal, however let's instead add an output to get that information. An output is a configurable piece of information that is highlighted at the end of a Terraform run

Add the following output into new file `outputs.tf`:

```hcl
output "client_certificate" {
  value     = azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks.kube_config_raw

  sensitive = true
}
```

Now run a `terraform refresh`, which will refresh your state file with the real-world infrastructure and resolve the new outputs you just created.

```sh
challenge02~  terraform refresh
random_string.storage-name: Refreshing state... [id=fojsdjwpkpim]
azurerm_resource_group.rg: Refreshing state... [id=/subscriptions/65ed073b-97bd-4fb8-a098-f1a6aaeb32f9/resourceGroups/challenge02-rg]
azurerm_storage_account.storageacount: Refreshing state... [id=/subscriptions/65ed073b-97bd-4fb8-a098-f1a6aaeb32f9/resourceGroups/challenge02-rg/providers/Microsoft.Storage/storageAccounts/fojsdjwpkpimsta]
azurerm_kubernetes_cluster.aks: Refreshing state... [id=/subscriptions/65ed073b-97bd-4fb8-a098-f1a6aaeb32f9/resourceGroups/challenge02-rg/providers/Microsoft.ContainerService/managedClusters/papcp-aks1]

Outputs:

client_certificate = <sensitive>
kube_config = <sensitive>
```

> Note: you can also run `terraform output` to see just these outputs without having to run refresh again.

### Clean up

When you are done, run `terraform destroy` to remove everything we created:

```sh
terraform destroy
```

## Resources

- [Azure Resource Group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group.html)
- [Azure Kubernetes Cluster](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster)
- [Azure Storage Account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)
- [Terraform Random Provider](https://registry.terraform.io/providers/hashicorp/random/latest/docs)


What's next?
==============

Once this section is completed, go back to [the agenda](../../README.md).
