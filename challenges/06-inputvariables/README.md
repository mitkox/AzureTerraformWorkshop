Challenge 06 - Input Variables
=======

In this challenge we introduce the concept of variables and different approaches to input variables into your deployment. 

A variable is a user or machine-supplied input in Terraform configurations. Variables can be supplied via environment variables, CLI flags, or variable files. Combined with modules, variables help make Terraform flexible, sharable, and extensible.

Terraform loads variables in the following order, with later sources taking precedence over earlier ones:

- **Environment variables:** Terraform will read environment variables in the form of TF_VAR_name. For example

	 ``env:TF_VAR_TOMATO = 'delicious’ ``

- **From a file:** the terraform.tfvars file, if present. The terraform.tfvars.json file, if present. Any *.auto.tfvars or *.tf Terraform will automatically load it to populate the variables,

- **Command line flags:** any -var and -var-file options on the command line, in the order they are provided. For example: 

    ``terraform apply –var 'resource_group_name' –var \ 'resource_group_location' –var 'resource_group_tag'``

## How to

## Create the configuration files and assign values to variables multiple ways

We will start with a few of the basic resources needed.

From the Cloud Shell, change directory into a folder specific to this challenge. If you created the scaffolding in Challenge 00, then then you can use the command `cd ~/AzureWorkChallenges/challenge06/`.

Create a `provider.tf` file with the following configuration:

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

Create a `main.tf` file with the following configuration:

```
resource "azurerm_resource_group" "test" {
  name     = var.rg
  location = var.location
}
```
Create a `variables.tf` file with the following configuration: 

```
variable "rg" {
  description = "Name of resource group to provision resources to."
}

variable "location" {
  description = "Azure region to put resources in"

}
```

First we will assigne values by using environment variables: 

```
export TF_VAR_rg=environmentvariables
export TF_VAR_location=westeurope
```
Plan and apply the configuration: 

```
terraform plan 
```
Now apply: 
```
terraform apply 
```
Check the resources created in Azure and verify that the variables has been properly assigned. 

The next level of precedence will be the variable file, let's create one called `terraform.tfvars`:

```
rg = "variablesfile" 
location = "eastus" 
```
Plan and apply the configuration: 

```
terraform plan 
```
Now apply: 
```
terraform apply 
```
Check the resources created in Azure and verify that the variables has been properly assigned. 

Now let's assign the value of the variables from CLI, run the following Terraform commands: 

``` terraform apply -var rg='commandline' -var location='northeurope' ```

Check the resources created in Azure and verify that the variables has been properly assigned. 

Since previous deployments were destroy we can verify the precedence on variable input and the order they take. 

### Clean up

When you are done, run `terraform destroy` to remove everything we created:

```sh
terraform destroy
azurerm_resource_group.test: Refreshing state... [id=/subscriptions/65ed073b-97bd-4fb8-a098-f1a6aaeb32f9/resourceGroups/commandline]

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # azurerm_resource_group.test will be destroyed
  - resource "azurerm_resource_group" "test" {
      - id       = "/subscriptions/65ed073b-97bd-4fb8-a098-f1a6aaeb32f9/resourceGroups/commandline" -> null
      - location = "northeurope" -> null
      - name     = "commandline" -> null
      - tags     = {} -> null
    }

Plan: 0 to add, 0 to change, 1 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value:
...
```



## Resources
- [Variables](https://www.terraform.io/docs/configuration/variables.html)

What's next?
==============

Once this section is completed, go back to [the agenda](../../README.md).
