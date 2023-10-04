# Challenge 04 - Terraform Modules

In this challenge, you will create a module to contain a scalable AKS cluster deployment, then create an environment where you will call the module.

A module in Terraform is a container for multiple resources that are used together. Modules can be used to create lightweight abstractions, so that you can describe your infrastructure in terms of its architecture, rather than directly in terms of physical objects.

## How to

### Create Folder Structure

From the Cloud Shell, change directory into a folder specific to this challenge. If you created the scaffolding in Challenge 00, then then you can use the command `cd ~/AzureWorkChallenges/challenge04/`.

In order to organize your code, create the following folder structure:

```sh
├── environments
│   └── dev
│       └── main.tf
└── modules
    └── my_aks_cluster
        └── main.tf
        └── variables.tf
        └── outputs.tf
        └── provider.tf
        
```

### Create the Module

Inside the `my_aks_cluster` module folder copy over the terraform configuration from challenge 02.

### Create Variables

Extract AKS name, Node count and VM size into variables without defaults in the file `variables.tf`, adjust also the variable name to "challenge04" and set clustercount to "1".

This will result in them being required.

```hcl
variable "clustercount" {
  default = 1
}

variable "aks_name" {}
variable "node_count" {}
variable "vm_size" {}
variable "environment" {}
```

Let's adjust `main.tf` to reference variables defined above:

```hcl
resource "azurerm_kubernetes_cluster" "aks" {
  name = "var.aks_name${count.index}"
  ...
  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.vm_size
  ...
    tags = {
    environment = var.environment
```


### Create the Environment

Change your working directory to the `environments/dev` folder.

Update `main.tf` to declare your module, it could look similar to this:

```hcl
module "myawesomeakscluster" {
  source   = "../../modules/my_aks_cluster"
  aks_name = "awesomeaks"
}
```

Create `variables.tf` to declare your variables:

```hcl
variable "environment" {}
```


> Notice the relative module sourcing.

### Terraform Init

Run `terraform init` followed by `terraform plan`.

```sh
 dev~  terraform plan
╷
│ Error: Missing required argument
│
│   on main.tf line 1, in module "myawesomeakscluster":
│    1: module "myawesomeakscluster" {
│
│ The argument "node_count" is required, but no definition was found.
╵
╷
│ Error: Missing required argument
│
│   on main.tf line 1, in module "myawesomeakscluster":
│    1: module "myawesomeakscluster" {
│
│ The argument "vm_size" is required, but no definition was found.
╵
╷
│ Error: Missing required argument
│
│   on main.tf line 1, in module "myawesomeakscluster":
│    1: module "myawesomeakscluster" {
│
│ The argument "environment" is required, but no definition was found.
```

We have a problem! We didn't set required variables for our module.

Update the `variables.tf` and `main.tf` files:

```hcl
variable "environment" {
    default = "dev"
}
```

```hcl
module "myawesomeakscluster" {
  source   = "../../modules/my_aks_cluster"
  aks_name = "awesomeaks"
  vm_size  = "Standard_D2_v2"
  node_count = 2
  environment = var.environment
}
```

Run `terraform init` again, this time there should not be any errors.

## Terraform Plan

Run `terraform plan` and you should see your linux VM built from your module.

```sh
✘  dev~  terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.myawesomeakscluster.azurerm_kubernetes_cluster.aks will be created
  + resource "azurerm_kubernetes_cluster" "aks" {
      + api_server_authorized_ip_ranges     = (known after apply)
      + dns_prefix                          = "dnsname"
      + fqdn                                = (known after apply)
      + http_application_routing_zone_name  = (known after apply)
      + id                                  = (known after apply)
      + image_cleaner_enabled               = false
      + image_cleaner_interval_hours        = 48
      + kube_admin_config                   = (sensitive value)
      + kube_admin_config_raw               = (sensitive value)
      + kube_config                         = (sensitive value)
      + kube_config_raw                     = (sensitive value)
      + kubernetes_version                  = (known after apply)
      + location                            = "centralus"
      + name                                = "awesomeaks"
      + node_resource_group                 = (known after apply)
      + node_resource_group_id              = (known after apply)
      + oidc_issuer_url                     = (known after apply)
      + portal_fqdn                         = (known after apply)
      + private_cluster_enabled             = false
      + private_cluster_public_fqdn_enabled = false
      + private_dns_zone_id                 = (known after apply)
      + private_fqdn                        = (known after apply)
      + public_network_access_enabled       = true
      + resource_group_name                 = "challenge04-rg"
      + role_based_access_control_enabled   = true
      + run_command_enabled                 = true
      + sku_tier                            = "Free"
      + tags                                = {
          + "Environment" = "Production"
        }
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

      + default_node_pool {
          + kubelet_disk_type    = (known after apply)
          + max_pods             = (known after apply)
          + name                 = "default"
          + node_count           = 2
          + node_labels          = (known after apply)
          + orchestrator_version = (known after apply)
          + os_disk_size_gb      = (known after apply)
          + os_disk_type         = "Managed"
          + os_sku               = (known after apply)
          + scale_down_mode      = "Delete"
          + type                 = "VirtualMachineScaleSets"
          + ultra_ssd_enabled    = false
          + vm_size              = "Standard_D2_v2"
          + workload_runtime     = (known after apply)
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
          + dns_service_ip      = (known after apply)
          + docker_bridge_cidr  = (known after apply)
          + ebpf_data_plane     = (known after apply)
          + ip_versions         = (known after apply)
          + load_balancer_sku   = (known after apply)
          + network_mode        = (known after apply)
          + network_plugin      = (known after apply)
          + network_plugin_mode = (known after apply)
          + network_policy      = (known after apply)
          + outbound_type       = (known after apply)
          + pod_cidr            = (known after apply)
          + pod_cidrs           = (known after apply)
          + service_cidr        = (known after apply)
          + service_cidrs       = (known after apply)

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

  # module.myawesomeakscluster.azurerm_resource_group.rg will be created
  + resource "azurerm_resource_group" "rg" {
      + id       = (known after apply)
      + location = "centralus"
      + name     = "challenge04-rg"
    }

  # module.myawesomeakscluster.azurerm_storage_account.storageacount will be created
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
      + resource_group_name               = "challenge04-rg"
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

  # module.myawesomeakscluster.random_string.storage-name will be created
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

Plan: 4 to add, 0 to change, 0 to destroy.
```

## Add Another Module

Add another `module` block describing another set of Virtual Machines:

```hcl
module "differentakscluster" {
  source   = "../../modules/my_aks_cluster"
  aks_name = "differentaks"
  vm_size  = "Standard_A2_v2"
  node_count = 1
  environment = var.environment
}
```

## Scale a single module

Set the count of your first module to 2 and rerun a plan.

```hcl
...
module "myawesomeakscluster" {
  source   = "../../modules/my_aks_cluster"
  aks_name = "awesomeaks"
  vm_size  = "Standard_D2_v2"
  node_count = 2
  environment = var.environment
  clustercount = 2
}
...
```

Run a plan and observer that your first module can scale independently of the second one.

## Terraform Plan

Since we added another module call, we must run `terraform init` again before running `terraform plan`.

We should see twice as much infrastructure in our plan.

```sh
  # module.myawesomeakscluster.azurerm_kubernetes_cluster.aks[0] will be created
  + resource "azurerm_kubernetes_cluster" "aks" {
      + api_server_authorized_ip_ranges     = (known after apply)
      + dns_prefix                          = "dnsname"
...

  # module.myawesomeakscluster.azurerm_kubernetes_cluster.aks[1] will be created
  + resource "azurerm_kubernetes_cluster" "aks" {
      + api_server_authorized_ip_ranges     = (known after apply)
      + dns_prefix                          = "dnsname"

...

Plan: 10 to add, 0 to change, 0 to destroy.

```

## More Variables

In your `environments/dev/variabes.tf` you have defined an environement variable which we can also override over `terraform.tfvars`.

Create a new file and name it `terraform.tfvars` that will contain our secrets and automatically loaded when we run a `plan`.

```hcl
envrionment = "prod"
```

## Terraform Plan

Run `terraform plan` and verify that your plan succeeds and looks the same.

## Advanced areas to explore

1. Use environment variables to load your secrets.


## Resources

- [Using Terraform Modules](https://www.terraform.io/docs/modules/usage.html)
- [Source Terraform Modiules](https://www.terraform.io/docs/modules/sources.html)

What's next?
==============

Once this section is completed, go back to [the agenda](../../README.md).
