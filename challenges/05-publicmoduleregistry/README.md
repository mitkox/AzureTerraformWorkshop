# Challenge 05 - Public Module Registry

In this challenge, you will take a look at the public [Module Registry](https://registry.terraform.io/) and create a Virtual Machine from verified ![](../../img/2018-05-14-07-27-11.png) Public Modules.

## How to

### Navigate the Public Module Registry

Open your browser and navigate to the [Module Registry](https://registry.terraform.io/). 

Search for "AKS" which will yield all compute resources in the registry.

Now Filter By 'azurerm' which should give you (among others) the Microsoft Azure Compute Module.

If you are having issues locating the module, you can find it directly at [https://registry.terraform.io/modules/Azure/aks/azurerm/latest](https://registry.terraform.io/modules/Azure/aks/azurerm/latest).

### Create Terraform Configuration


From the Cloud Shell, change directory into a folder specific to this challenge. If you created the scaffolding in Challenge 00, then then you can use the command `cd ~/AzureWorkChallenges/challenge05/`.

To create an Azure Kubernetes Clusterwe need a resource group in place, to do so we will create one before calling the AKS module.

Create a `main.tf` file in this directory, create Resource Group and add the AKS module.

The following will configure the module to create a single Virtual Network and a Subnet.

```hcl
resource "azurerm_resource_group" "rg" {
  name     = "challenge05-rg"
  location = "centralus"
}

module "aks" {
  source              = "Azure/aks/azurerm"
  resource_group_name = "challenge05-rg"
}
```

Run a `terraform init` and `terraform plan` to verify that all the resources look correct.

```sh
Initializing modules...
Downloading registry.terraform.io/Azure/aks/azurerm 7.4.0 for aks...
- aks in .terraform/modules/aks

Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/azurerm versions matching ">= 3.69.0, < 4.0.0"...
- Finding azure/azapi versions matching ">= 1.4.0, < 2.0.0"...
- Finding hashicorp/null versions matching ">= 3.0.0"...
- Finding hashicorp/tls versions matching ">= 3.1.0"...
- Installing azure/azapi v1.9.0...
- Installed azure/azapi v1.9.0 (signed by a HashiCorp partner, key ID 6F0B91BDE98478CF)
- Installing hashicorp/null v3.2.1...
- Installed hashicorp/null v3.2.1 (signed by HashiCorp)
- Installing hashicorp/tls v4.0.4...
- Installed hashicorp/tls v4.0.4 (signed by HashiCorp)
- Installing hashicorp/azurerm v3.75.0...
- Installed hashicorp/azurerm v3.75.0 (signed by HashiCorp)

Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://www.terraform.io/docs/cli/plugins/signing.html

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```


```sh

```

Run `terraform apply` to create the infrastructure.

### View Outputs

The Public Registry contains a lot of information about the module. Navigate to the outputs tab for the [Networking Module](https://registry.terraform.io/modules/Azure/network/azurerm/2.0.0?tab=outputs).

We can see the outputs we should expect and a short description of each of them.

![](../../img/2018-05-14-08-18-48.png)

Now that we have the networking infrastructure applied, we can view the outputs with terraform by running `terraform output -module network`.

> Note: Because we are using a module, the outputs are not available at the root module, hence the need to specify the `-module network` option.

```sh
$ terraform output -module network
vnet_address_space = [
    10.0.0.0/16
]
vnet_id = /subscriptions/.../resourceGroups/myapp-networking/providers/Microsoft.Network/virtualNetworks/acctvnet
vnet_location = centralus
vnet_name = acctvnet
vnet_subnets = [
    /subscriptions/.../resourceGroups/myapp-networking/providers/Microsoft.Network/virtualNetworks/acctvnet/subnets/subnet1
]
```

### Add Compute Module - Windows

With Networking in place you can now add the Compute module to create a Windows Virtual Machine.

```hcl
module "windowsservers" {
  source              = "Azure/compute/azurerm"
  version             = "1.1.5"
  resource_group_name = "myapp-compute-windows"
  location            = "centralus"
  admin_password      = "ComplxP@ssw0rd!"
  vm_os_simple        = "WindowsServer"
  nb_public_ip        = 0
  vnet_subnet_id      = "${module.network.vnet_subnets[0]}"
}
```

Run a `terraform init` and `terraform plan` to verify that all the resources look correct.

When running a plan you may run into the following error:
![](../../img/2018-06-07-16-23-29.png)

To get past this, simply run the `az login` command and follow the prompts.

> **Note:** Take a minute to analyse why you needed to run another `terraform init` command before you could run a plan.



```sh
 challenge05~  terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
 <= read (data resources)

Terraform will perform the following actions:

  # azurerm_resource_group.rg will be created
  + resource "azurerm_resource_group" "rg" {
      + id       = (known after apply)
      + location = "centralus"
      + name     = "challenge05-rg"
    }

  # module.aks.data.azurerm_resource_group.main will be read during apply
  # (depends on a resource or a module with changes pending)
 <= data "azurerm_resource_group" "main" {
      + id         = (known after apply)
      + location   = (known after apply)
      + managed_by = (known after apply)
      + name       = "challenge05-rg"
      + tags       = (known after apply)

      + timeouts {
          + read = (known after apply)
        }
    }

  # module.aks.azapi_update_resource.aks_cluster_post_create will be created
  + resource "azapi_update_resource" "aks_cluster_post_create" {
      + body                    = jsonencode(
            {
              + properties = {
                  + kubernetesVersion = null
                }
            }
        )
      + id                      = (known after apply)
      + ignore_casing           = false
      + ignore_missing_property = true
      + name                    = (known after apply)
      + output                  = (known after apply)
      + parent_id               = (known after apply)
      + resource_id             = (known after apply)
      + type                    = "Microsoft.ContainerService/managedClusters@2023-01-02-preview"
    }

  # module.aks.azurerm_kubernetes_cluster.main will be created
  + resource "azurerm_kubernetes_cluster" "main" {
      + api_server_authorized_ip_ranges     = (known after apply)
      + azure_policy_enabled                = false
      + dns_prefix                          = "pcp"
      + fqdn                                = (known after apply)
      + http_application_routing_enabled    = false
      + http_application_routing_zone_name  = (known after apply)
      + id                                  = (known after apply)
      + image_cleaner_enabled               = false
      + image_cleaner_interval_hours        = 48
      + kube_admin_config                   = (sensitive value)
      + kube_admin_config_raw               = (sensitive value)
      + kube_config                         = (sensitive value)
      + kube_config_raw                     = (sensitive value)
      + kubernetes_version                  = (known after apply)
      + location                            = (known after apply)
      + name                                = "pcp-aks"
      + node_resource_group                 = (known after apply)
      + node_resource_group_id              = (known after apply)
      + oidc_issuer_enabled                 = false
      + oidc_issuer_url                     = (known after apply)
      + portal_fqdn                         = (known after apply)
      + private_cluster_enabled             = false
      + private_cluster_public_fqdn_enabled = false
      + private_dns_zone_id                 = (known after apply)
      + private_fqdn                        = (known after apply)
      + public_network_access_enabled       = true
      + resource_group_name                 = "challenge05-rg"
      + role_based_access_control_enabled   = true
      + run_command_enabled                 = true
      + sku_tier                            = "Free"
      + workload_identity_enabled           = false

      + api_server_access_profile {
          + authorized_ip_ranges     = (known after apply)
          + subnet_id                = (known after apply)
          + vnet_integration_enabled = (known after apply)
        }

      + auto_scaler_profile {
          + balance_similar_node_groups      = (known after apply)
          + empty_bulk_delete_max            = (known after apply)
          + expander                         = (known after apply)
          + max_graceful_termination_sec     = (known after apply)
          + max_node_provisioning_time       = (known after apply)
          + max_unready_nodes                = (known after apply)
          + max_unready_percentage           = (known after apply)
          + new_pod_scale_up_delay           = (known after apply)
          + scale_down_delay_after_add       = (known after apply)
          + scale_down_delay_after_delete    = (known after apply)
          + scale_down_delay_after_failure   = (known after apply)
          + scale_down_unneeded              = (known after apply)
          + scale_down_unready               = (known after apply)
          + scale_down_utilization_threshold = (known after apply)
          + scan_interval                    = (known after apply)
          + skip_nodes_with_local_storage    = (known after apply)
          + skip_nodes_with_system_pods      = (known after apply)
        }

      + azure_active_directory_role_based_access_control {
          + managed   = false
          + tenant_id = (known after apply)
        }

      + default_node_pool {
          + enable_auto_scaling    = false
          + enable_host_encryption = false
          + enable_node_public_ip  = false
          + kubelet_disk_type      = (known after apply)
          + max_pods               = (known after apply)
          + name                   = "nodepool"
          + node_count             = 2
          + node_labels            = (known after apply)
          + orchestrator_version   = (known after apply)
          + os_disk_size_gb        = 50
          + os_disk_type           = "Managed"
          + os_sku                 = (known after apply)
          + scale_down_mode        = "Delete"
          + type                   = "VirtualMachineScaleSets"
          + ultra_ssd_enabled      = false
          + vm_size                = "Standard_D2s_v3"
          + workload_runtime       = (known after apply)
        }

      + identity {
          + principal_id = (known after apply)
          + tenant_id    = (known after apply)
          + type         = "SystemAssigned"
        }

      + kubelet_identity {
          + client_id                 = (known after apply)
          + object_id                 = (known after apply)
          + user_assigned_identity_id = (known after apply)
        }

      + network_profile {
          + dns_service_ip     = (known after apply)
          + docker_bridge_cidr = (known after apply)
          + ip_versions        = (known after apply)
          + load_balancer_sku  = "standard"
          + network_mode       = (known after apply)
          + network_plugin     = "kubenet"
          + network_policy     = (known after apply)
          + outbound_type      = "loadBalancer"
          + pod_cidr           = (known after apply)
          + pod_cidrs          = (known after apply)
          + service_cidr       = (known after apply)
          + service_cidrs      = (known after apply)

          + load_balancer_profile {
              + effective_outbound_ips      = (known after apply)
              + idle_timeout_in_minutes     = (known after apply)
              + managed_outbound_ip_count   = (known after apply)
              + managed_outbound_ipv6_count = (known after apply)
              + outbound_ip_address_ids     = (known after apply)
              + outbound_ip_prefix_ids      = (known after apply)
              + outbound_ports_allocated    = (known after apply)
            }

          + nat_gateway_profile {
              + effective_outbound_ips    = (known after apply)
              + idle_timeout_in_minutes   = (known after apply)
              + managed_outbound_ip_count = (known after apply)
            }
        }

      + oms_agent {
          + log_analytics_workspace_id = (known after apply)
          + oms_agent_identity         = (known after apply)
        }

      + windows_profile {
          + admin_password = (sensitive value)
          + admin_username = (known after apply)
          + license        = (known after apply)

          + gmsa {
              + dns_server  = (known after apply)
              + root_domain = (known after apply)
            }
        }
    }

  # module.aks.azurerm_log_analytics_solution.main[0] will be created
  + resource "azurerm_log_analytics_solution" "main" {
      + id                    = (known after apply)
      + location              = (known after apply)
      + resource_group_name   = "challenge05-rg"
      + solution_name         = "ContainerInsights"
      + workspace_name        = "sjhdsajhdkjsahdjksahkdjhsajkd"
      + workspace_resource_id = (known after apply)

      + plan {
          + name      = (known after apply)
          + product   = "OMSGallery/ContainerInsights"
          + publisher = "Microsoft"
        }
    }

  # module.aks.azurerm_log_analytics_workspace.main[0] will be created
  + resource "azurerm_log_analytics_workspace" "main" {
      + allow_resource_only_permissions = true
      + daily_quota_gb                  = -1
      + id                              = (known after apply)
      + internet_ingestion_enabled      = true
      + internet_query_enabled          = true
      + local_authentication_disabled   = false
      + location                        = (known after apply)
      + name                            = "sjhdsajhdkjsahdjksahkdjhsajkd"
      + primary_shared_key              = (sensitive value)
      + resource_group_name             = "challenge05-rg"
      + retention_in_days               = 30
      + secondary_shared_key            = (sensitive value)
      + sku                             = "PerGB2018"
      + workspace_id                    = (known after apply)
    }

  # module.aks.null_resource.kubernetes_version_keeper will be created
  + resource "null_resource" "kubernetes_version_keeper" {
      + id       = (known after apply)
      + triggers = {
          + "version" = null
        }
    }

Plan: 6 to add, 0 to change, 0 to destroy.
╷
│ Warning: Argument is deprecated
│
│   with module.aks.azurerm_kubernetes_cluster.main,
│   on .terraform/modules/aks/main.tf line 34, in resource "azurerm_kubernetes_cluster" "main":
│   34:   public_network_access_enabled       = var.public_network_access_enabled
│
│ `public_network_access_enabled` is currently not functional and is not be passed to the API
╵

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```

Before applying, take a look at all the resources that are going to be created from our simple `module` block.

Run `terraform apply` to create the infrastructure.

### Clean up

Run `terraform destroy` to remove everything we created.

## Resources

- [Azurerm Public Registry AKS module](https://registry.terraform.io/modules/Azure/aks/azurerm/latest?tab=inputs)
- [Source Code Puclic Registry AKS module](https://registry.terraform.io/modules/Azure/aks/azurerm/latest?tab=inputs)

What's next?
==============

Once this section is completed, go back to [the agenda](../../README.md).
