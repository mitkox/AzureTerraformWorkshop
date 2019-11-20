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

## Create a Service Principal


# Configure Vnet and Default Subnet

We will start with a few of the basic resources needed.

From the Cloud Shell, change directory into a folder specific to this challenge. If you created the scaffolding in Challenge 00, then then you can use the command `cd ~/AzureWorkChallenges/challenge06/`.

Create a `provider.tf` file with the following configuration:

```hcl
provider "azurerm" {
  version = "= 1.36"
}

terraform {
  required_version = "= 0.12.12"
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
  type        = "string"
  description = "Name of resource group to provision resources to."
}

variable "location" {
  type        = "string"
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

Plan and apply the configuration: 

```
terraform plan 
```
Now apply: 
```
terraform apply 
```

Check the resources created in Azure and verify that the variables has been properly assigned. 


