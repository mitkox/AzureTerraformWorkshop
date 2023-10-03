# Challenge 01 - Connection To Azure


In this challenge, you will use Terraform from the Azure Cloud Shell to create simple infrastructure in your Azure Subscription.

In this challenge, you will:

- Initialize Terraform
- Use `fmt` to format your templates
- Run a `plan` on simple a simple resource
- Run an `apply` to create Azure infrastructure
- Run a `destroy` to remove Azure infrastructure

## How To

### Create Terraform Configuration

From the Cloud Shell, change directory into a folder specific to this challenge. If you created the scaffolding in Challenge 00, then then you can use the command `cd ~/AzureWorkChallenges/challenge01/`.

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

Create another file named `main.tf` and add a single Resource Group resource. You can use the command **code** to open a text editor on cloudshell.

```hcl
resource "azurerm_resource_group" "test" {
name     = "challenge01-rg"
location = "centralus"
}
```

Save the filees an exit. This will create a simple Resource Group and allow you to walk through the Terraform Workflow however you can see the format is not properly set as you would on a JSON file, you could edit it your self or run the command **terraform fmt**.

Verify format: 

```
$ cat main.tf
resource "azurerm_resource_group" "test" {
name     = "challenge01-rg"
location = "centralus"
}
```

Format the file: 

```
$ terraform fmt
main.tf
```

Check the new format: 

```
$ cat main.tf
resource "azurerm_resource_group" "test" {
  name     = "challenge01-rg"
  location = "centralus"
}
```

### Run the Terraform Workflow

As described before in order to deploy a resource using terraform we need to run init, plan and apply. Let's start with init: 

```
challenge01~  terraform init

Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/azurerm versions matching "3.75.0"...
- Installing hashicorp/azurerm v3.75.0...
- Installed hashicorp/azurerm v3.75.0 (signed by HashiCorp)

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
commands will detect it and remind you to do so if necessary..
```
---

Now that we have initialize we can plan out deployment by running terraform plan: 

```
challenge01~  terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_resource_group.test will be created
  + resource "azurerm_resource_group" "test" {
      + id       = (known after apply)
      + location = "centralus"
      + name     = "challenge01-rg"
    }

Plan: 1 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.
```

Now we can actually deploy the resources by running the command below, you will need to confirm by typing "yes".

---
```
$ terraform apply`
An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_resource_group.test will be created
  + resource "azurerm_resource_group" "test" {
      + id       = (known after apply)
      + location = "centralus"
      + name     = "challenge01-rg"
      + tags     = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

azurerm_resource_group.test: Creating...
azurerm_resource_group.test: Creation complete after 0s [id=/subscriptions/xxxx-xxxx-xxxxx/resourceGroups/challenge01-rg]
```
---

Congrats, you just created your first Azure resource using Terraform!

### Verify in the Azure Portal

Head over to the [Azure Portal](https://portal.azure.com/)

View all Resource Groups and you should see the recently created Resource Group.
![](../../img/2018-05-09-10-20-28.png)


### Cleanup Resources

When you are done, destroy the infrastructure, we no longer need it.

```sh
$ terraform destroy
azurerm_resource_group.main: Refreshing state... (ID: /subscriptions/.../resourceGroups/challenge01-rg)
azurerm_resource_group.count[0]: Refreshing state... (ID: /subscriptions/.../resourceGroups/challenge01-rg-0)
azurerm_resource_group.count[1]: Refreshing state... (ID: /subscriptions/.../resourceGroups/challenge01-rg-1)

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  - azurerm_resource_group.count
  - azurerm_resource_group.main


Plan: 0 to add, 0 to change, 2 to destroy.

Do you really want to destroy?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

azurerm_resource_group.main: Destroying... (ID: /subscriptions/.../resourceGroups/challenge01-rg)
azurerm_resource_group.count[1]: Destroying... (ID: /subscriptions/.../resourceGroups/challenge01-rg-1)
azurerm_resource_group.count[0]: Destroying... (ID: /subscriptions/.../resourceGroups/challenge01-rg-0)
azurerm_resource_group.count.0: Still destroying... (ID: /subscriptions/.../resourceGroups/challenge01-rg-0, 10s elapsed)
azurerm_resource_group.main: Still destroying... (ID: /subscriptions/.../resourceGroups/challenge01-rg, 10s elapsed)
azurerm_resource_group.count.1: Still destroying... (ID: /subscriptions/.../resourceGroups/challenge01-rg-1, 10s elapsed)
azurerm_resource_group.count.1: Still destroying... (ID: /subscriptions/.../resourceGroups/challenge01-rg-1, 20s elapsed)
azurerm_resource_group.count.0: Still destroying... (ID: /subscriptions/.../resourceGroups/challenge01-rg-0, 20s elapsed)
azurerm_resource_group.main: Still destroying... (ID: /subscriptions/.../resourceGroups/challenge01-rg, 20s elapsed)
azurerm_resource_group.count.1: Still destroying... (ID: /subscriptions/.../resourceGroups/challenge01-rg-1, 30s elapsed)
azurerm_resource_group.count.0: Still destroying... (ID: /subscriptions/.../resourceGroups/challenge01-rg-0, 30s elapsed)
azurerm_resource_group.main: Still destroying... (ID: /subscriptions/.../resourceGroups/challenge01-rg, 30s elapsed)
azurerm_resource_group.count.0: Still destroying... (ID: /subscriptions/.../resourceGroups/challenge01-rg-0, 40s elapsed)
azurerm_resource_group.count.1: Still destroying... (ID: /subscriptions/.../resourceGroups/challenge01-rg-1, 40s elapsed)
azurerm_resource_group.main: Still destroying... (ID: /subscriptions/.../resourceGroups/challenge01-rg, 40s elapsed)
azurerm_resource_group.main: Destruction complete after 47s
azurerm_resource_group.count[0]: Destruction complete after 47s
azurerm_resource_group.count[1]: Destruction complete after 47s

Destroy complete! Resources: 2 destroyed.
```

---


#### CHEAT SHEETS
<details>
<summary>
Expand for full provider.tf and main.tf code
</summary>

```terraform
resource "azurerm_resource_group" "test" {
  name     = "challenge01-rg"
  location = "centralus"
}
```
```terraform
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

</details>

## How To - Part 2 (Import Resources)

By default, Terraform only manages previously created resources using Terraform, and therefore they are described in onw of the templates. You can also, importe resources, meaning handle services that were created outside of Terraform for example using the portal. 

However, the import functionality of Terraform only writes the state file and lets Terraform know about the existance of those resources, however it will not create the Terraform configuration files. 

**Critical Thinking**

After importing an existing resource, what operation(s) would the terraform plan show?

`Answer`
<details><summary>View Answer</summary>
<p>
```
Destroy: state exists as it was imported but there is no configuration file for it in Terraform
```
</p>
</details>

The following challenge will showcase the process to import resources into Terraform. 

### Create Infrastructure in the Portal

First, we need to create some resources outside of Terraform in order to later on import them. For that navigate to the Azure Portal and click on the `Resource groups` item on the left side and then click  `+ Add`:

![](../../img/2018-05-28-13-58-49.png)

In the Resource Group create blade give the resource group the name `myportal-rg`, keep the location to `Central US` and click `Create`":

![](../../img/2018-05-28-14-01-30.png)

Once the Resource Group is created, navigate to it.

Find the `+ Add` button and click it:

![](../../img/2018-05-28-14-03-05.png)

Search for `Storage Account` and click the first item and then click `Create`:

![](../../img/2018-05-28-14-04-39.png)


In the Storage Account create blade, fill out the following:

- **Name:** Must be a unique name, there will be a green checkmark that shows up in the text box if your name is available. Example "<YOURUSERNAME>storageaccount"
- **Replication:** LRS
- **Location:** Central US
- **Account Type:** Storage (general purpose v1)
- **Performance:** Standard 
- **Resource Group:** Use Existing and select "myportal-rg"
- **Secure transfer required:** Disabled. This parameter can be found on the Advanced->Security tab


![](../../img/2018-05-28-14-05-39.png)

Click `Create`

At this point we have a Resource Group and a Storage Account and are ready to import this into Terraform.

![](../../img/2018-05-28-14-09-39.png)

### Create Terraform Configuration

Now that we have created the resources using the portal, we also need to create its Terraform configuration file, otherwise it will be deleted since it is not described there. 

Your Azure Cloud Shell should still be in the folder for this challenge with a single `main.tf` file.
Delete the contents of that file so we can start from scratch.

We have two resources we need to import into our Terraform Configuration, to do this we need to do two things:

1. Create the base Terraform configuration for both resources.
2. Run `terraform import` to bring the infrastructure into our state file.

To create the base configuration place the following code into the `main.tf` file.

```hcl
resource "azurerm_resource_group" "main" {
  name     = "myportal-rg"
  location = "centralus"
}

resource "azurerm_storage_account" "main" {
  name                     = "myusernamestorageaccount"
  resource_group_name      = "azurerm_resource_group.main.name"
  location                 = "centralus"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

```
Verify the terraform plan output, it says it will add 2 resources. 

```
$terraform init

Initializing the backend...

Initializing provider plugins...
- Checking for available provider plugins...
- Downloading plugin for provider "azurerm" (hashicorp/azurerm) 1.36.1...

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, it is recommended to add version = "..." constraints to the
corresponding provider blocks in configuration, with the constraint strings
suggested below.

* provider.azurerm: version = "~> 1.36"

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

```
$ terraform plan

Terraform will perform the following actions:

  + azurerm_resource_group.main
      id:                               <computed>
      location:                         "centralus"
      name:                             "myportal-rg"
      tags.%:                           <computed>

  + azurerm_storage_account.main
      id:                               <computed>
      access_tier:                      <computed>
      account_encryption_source:        "Microsoft.Storage"
      account_kind:                     "Storage"
      account_replication_type:         "LRS"
      account_tier:                     "Standard"
      enable_blob_encryption:           <computed>
      enable_file_encryption:           <computed>
      location:                         "centralus"
      name:                             "myusernamestorageaccount"
      primary_access_key:               <computed>
      primary_blob_connection_string:   <computed>
      primary_blob_endpoint:            <computed>
      primary_connection_string:        <computed>
      primary_file_endpoint:            <computed>
      primary_location:                 <computed>
      primary_queue_endpoint:           <computed>
      primary_table_endpoint:           <computed>
      resource_group_name:              "myportal-rg"
      secondary_access_key:             <computed>
      secondary_blob_connection_string: <computed>
      secondary_blob_endpoint:          <computed>
      secondary_connection_string:      <computed>
      secondary_location:               <computed>
      secondary_queue_endpoint:         <computed>
      secondary_table_endpoint:         <computed>
      tags.%:                           <computed>


Plan: 2 to add, 0 to change, 0 to destroy.
```

> **CAUTION:** This is not what we want! You already have those resources created so we need to import them to let Terraform know.

### Import the Resource Group

We need two values to run the `terraform import` command:

1. Resource Address from our configuration
1. Azure Resource ID

The Resource Address is simple enough, based on the configuration above it is simply "azurerm_resource_group.main".

The Azure Resource ID can be retrieved using the Azure CLI by running `az group show -g myportal-rg --query id`. The value should look something like "/subscriptions/xxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/myportal-rg".

Now run the import command:

```sh
$ terraform import azurerm_resource_group.main /subscriptionsxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/myportal-rg

Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.
```

### Import the Storage Account

The process here is the same.

The Resource Address is simple enough, based on the configuration above it is simply "azurerm_storage_account.main".

The Azure Resource ID can be retrieved using the Azure CLI by running `az storage account show -g myportal-rg -n myusernamestorageaccount --query id`. The value should look something like "/subscriptions/xxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/myportal-rg/providers/Microsoft.Storage/storageAccounts/myusernamestorageaccount".

```sh
$ terraform import azurerm_storage_account.main /subscriptions/xxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/myportal-rg/providers/Microsoft.Storage/storageAccounts/myusernamestorageaccount

Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.
```

### Verify Plan

Run a `terraform plan`, you should see "No changes. Infrastructure is up-to-date.".

### Make a Change

Add the following tag configuration to both the Resource Group and the Storage Account:

 > **CAUTION:** Do not copy and paste the entire file, add the tag section accordingly on your current configuration. 

```hcl
resource "azurerm_resource_group" "main" {
  ...
  tags = {
    terraform = "true"
  }
}

resource "azurerm_storage_account" "main" {
  ...
  tags = {
    terraform = "true"
  }
}
```

Run a plan, we should see two changes.

```sh
  ~ azurerm_resource_group.main
      tags.%:         "0" => "1"
      tags.terraform: "" => "true"

  ~ azurerm_storage_account.main
      tags.%:         "0" => "1"
      tags.terraform: "" => "true"


Plan: 0 to add, 2 to change, 0 to destroy.
```

Apply those changes.

SUCCESS! You have now brought existing infrastructure into Terraform.

### Cleanup

Because the infrastructure is now managed by Terraform, we can destroy just like before.

Run a `terraform destroy` and follow the prompts to remove the infrastructure.

## Advanced areas to explore

1. Run the `plan` command with the `-out` option and apply that output.
1. Add tags to each resource.

## Resources

- [Terraform Azure Resouce Group](https://www.terraform.io/docs/providers/azurerm/r/resource_group.html)
- [Terraform Azure Storage Account](https://www.terraform.io/docs/providers/azurerm/r/storage_account.html)
- [Terraform Import Command](https://www.terraform.io/docs/import/index.html)
- [Running Terraform in Automation](https://learn.hashicorp.com/terraform/development/running-terraform-in-automation)

What's next?
==============

Once this section is completed, go back to [the agenda](../../README.md).
