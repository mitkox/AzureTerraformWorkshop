Challenge 00 - Getting Started
=======

In this challenge, you will connect to the [Azure Cloud Shell](https://azure.microsoft.com/en-us/features/cloud-shell/) that will be needed for future challenges.

Cloud Shell is a free (excl. storage cost) service which provides you a virtual Linux server in a container, including pre-installed Azure CLI.

In this challenge, you will:

- Login to the Azure Portal
- Verify `az` installation
- Verify `terraform` installation
- Create a folder structure to complete challenges

> **Note:** If you would rather complete the challenges from you local worskstation and install terraform, detailed instructions can be found [here](local.md).

## How to

### Login to the Azure Portal

Navigate to [https://portal.azure.com](https://portal.azure.com) and login with your Azure Credentials.

### Open the Cloud Shell

Located at the top of the page is the button open the Azure Cloud Shell inside the Azure Portal.

![](../../img/2018-05-28-12-25-01.png)

> **Note:** Another option is to use the full screen Azure Cloud Shell at [https://shell.azure.com/](https://shell.azure.com/).

The first time you connect to the Azure Cloud Shell you will be prompted to setup an Azure File Share that you will persist the environment.

![](../../img/2018-05-28-12-27-31.png)

Click the "Bash (Linux)" option.

Select the Azure Subscription and click "Create storage":

![](../../img/2018-05-28-12-29-06.png)

After a few seconds you should see that your storage account has been created:

![](../../img/2018-05-28-12-30-33.png)

>** Note:** Behind the scenes this is creating a new Resource Group with the name `cloud-shell-storage-eastus` (or which ever region you defaulted to). If you need more information, it can be found [here](https://docs.microsoft.com/en-us/azure/cloud-shell/persisting-shell-storage).

SUCCESS!
You are now logged into the Azure Cloud Shell which uses your portal session to automatically authenticate you with the Azure CLI and Terraform.

### Verify Utilities

In the Cloud Shell type the following commands and verify that the utilities are installed:

`az -v`

<details><summary>View Output</summary>
<p>

```sh
$ az -v
azure-cli                         2.0.76

command-modules-nspkg              2.0.3
core                              2.0.76
nspkg                              3.0.4
telemetry                          1.0.4

Python location '/opt/az/bin/python3'
Extensions directory '/home/lanicola/.azure/cliextensions'

Python (Linux) 3.6.5 (default, Oct 30 2019, 06:32:16)
[GCC 5.4.0 20160609]

Legal docs and information: aka.ms/AzureCliLegal


Your CLI is up-to-date.
```
</p>
</details>

`terraform -v`

<details><summary>View Output</summary>
<p>

```sh
$ terraform -v
Terraform v0.12.12

Your version of Terraform is out of date! The latest version
is 0.12.16. You can update by downloading from www.terraform.io/downloads.html
```

</p>
</details>

### Verify Subscription

Run the command `az account list -o table`.

```sh
az account list -o table
Name                             CloudName    SubscriptionId                        State    IsDefault
-------------------------------  -----------  ------------------------------------  -------  -----------
Visual Studio Premium with MSDN  AzureCloud   xxxxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx  Enabled  True
Another sub1                     AzureCloud   xxxxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx  Enabled  False
Another sub2                     AzureCloud   xxxxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx  Enabled  False
Another sub3                     AzureCloud   xxxxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx  Enabled  False
```

If you have more than subscription, make sure that subscription is set as default using the subscription name (use the one that matches your environment):

```sh
az account set -s 'Visual Studio Premium with MSDN'
```

### Create Challenge Scaffolding

To make things easy for the challenges, let's create a folder structure to hold the terraform configuration we will create.

Make sure you are in the home directory:

```sh
cd ~/
```

Run the following in the azure cloud shell, this will simply create a folder structure for you to place your Terraform configuration:

```sh
mkdir AzureWorkChallenges && cd AzureWorkChallenges && mkdir challenge01 && mkdir challenge02 && mkdir challenge03 && mkdir challenge04 && mkdir challenge05 && mkdir challenge06 && mkdir challenge07
```

What you should end up with is a structure like this:

```sh
AzureWorkChallenges
|- challenge01
|- challenge02
|- challenge03
|- challenge04
|- challenge05
|- challenge06
|- challenge07
```
What's next?
==============

Once this section is completed, go back to [the agenda](../../README.md).