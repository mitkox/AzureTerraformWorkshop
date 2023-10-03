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
