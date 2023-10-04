# Challenge 03 - Terraform Count


In this challenge, you will take what you did in Challenge 02 and expand to take a count variable.

The count parameter on resources can simplify configurations and let you scale resources by simply incrementing a number.
Additionally, variables can be used to expand a list of resources for use elsewhere.

**Note:** Be aware that if you did not destroy the infrastructure from Challenge 02 you may run into resource naming conflicts (namely "Resource already exists").

## How to

### Update Configuration to reflect the count parameter

From the Cloud Shell, change directory into a folder specific to this challenge. If you created the scaffolding in Challenge 00, then you can use the command `cd ~/AzureWorkChallenges/challenge03/`.

Copy the all *.tf files from challenge 02 into the current directory.

Now that we have created a baseline we will update it to scale using the count parameter: 

Be sure to update the value of the `name` variable in `variables.tf`:

```hcl
variable "name" {
  default = "challenge03"
}
```

### Add a count variable

Create a new variable called `clustercount` and default it to `1`.

```hcl
variable "clustercount" {
  default = 1
}
```

### Update Existing Resources

Not every resource needs to scale as the number of VM's increase.

The Resource Group, Virtual Network and Subnet will not change.

We will have to scale the Network Interface, Public IP, and VM resources.

Each of these resources you will need make these changes in `main.tf`:

 > **Caution:** you will need to do these steps for resources that need to scale, only some of the examples are shown. 

- Add the count variable for AKS and Storage Account resource:

```hcl
    count = var.clusteracount
```

- Update the resource name for the AKS cluster to include the count index:

```hcl
    name = "papcp-aks${count.index}"
```

- Update resource name for the Storage Accoubt to include the count index as well:

```hcl
        name = "${random_string.storage-name.result}sta${count.index}"
```
- Update the Client Certificate outputs to display an array of certificates:

```hcl
      value = azurerm_kubernetes_cluster.aks.*.kube_config.0.client_certificate
```

- Update the Kube Config outputs to display an array of configs:

```hcl
    value = azurerm_kubernetes_cluster.aks.*.kube_config_raw
```

### Run a plan

If all the changes above have been made without error, runnning `terraform init` and `terraform plan` should execute without any errors.

The plan should end with:

```sh
Plan: 3 to add, 0 to change, 0 to destroy.
```

Now investigate this plan in more detail and you will notice that names have been set using the count index:

```sh
  # azurerm_kubernetes_cluster.aks[1] will be created
  + resource "azurerm_kubernetes_cluster" "aks" {
      + api_server_authorized_ip_ranges     = (known after apply)
      + dns_prefix                          = "dnsname"
      + fqdn                                = (known after apply)

```

### Update Count

Set the default value of the count to `2` in `variables.tf`.
Before running a plan consider the following questions:

- How many resources do expect the plan to show?
- What will the outputs look like?

Your plan should look similar to the following

```
 challenge03~  terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_kubernetes_cluster.aks[0] will be created
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
      + name                                = "papcp-aks0"
      + node_resource_group                 = (known after apply)
      + node_resource_group_id              = (known after apply)
      + oidc_issuer_url                     = (known after apply)
      + portal_fqdn                         = (known after apply)
      + private_cluster_enabled             = false
      + private_cluster_public_fqdn_enabled = false
      + private_dns_zone_id                 = (known after apply)
      + private_fqdn                        = (known after apply)
      + public_network_access_enabled       = true
      + resource_group_name                 = "challenge03-rg"
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
          + node_count           = 1
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

  # azurerm_kubernetes_cluster.aks[1] will be created
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
      + name                                = "papcp-aks1"
      + node_resource_group                 = (known after apply)
      + node_resource_group_id              = (known after apply)
      + oidc_issuer_url                     = (known after apply)
      + portal_fqdn                         = (known after apply)
      + private_cluster_enabled             = false
      + private_cluster_public_fqdn_enabled = false
      + private_dns_zone_id                 = (known after apply)
      + private_fqdn                        = (known after apply)
      + public_network_access_enabled       = true
      + resource_group_name                 = "challenge03-rg"
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
          + node_count           = 1
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

  # azurerm_resource_group.rg will be created
  + resource "azurerm_resource_group" "rg" {
      + id       = (known after apply)
      + location = "centralus"
      + name     = "challenge03-rg"
    }

  # azurerm_storage_account.storageacount[0] will be created
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
      + resource_group_name               = "challenge03-rg"
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

  # azurerm_storage_account.storageacount[1] will be created
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
      + resource_group_name               = "challenge03-rg"
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

Plan: 6 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + client_certificate = (sensitive value)
  + kube_config        = (sensitive value)
 
Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```

Run `terraform apply` to create all the infrastructure.

### Azure Portal

In the Azure Portal, view all the resources in the `challenge03-rg` Resource Group.

How important do think naming is?

How can Terraform help with keeping things consistent?

### Clean up

Run `terraform destroy` to remove everything we created.

What's next?
==============

Once this section is completed, go back to [the agenda](../../README.md).
