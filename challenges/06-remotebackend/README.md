# Challenge 06 - Remote Backend

In this challenge, you will move your state file to a remote backend.

Terraform stores the state of your managed infrastructure from the last time Terraform was run. Terraform uses this state to create plans and make changes to your infrastructure, it is critical that this state is maintained appropriately so future runs operate as expected.

There are 2 types of backends: 
1. **Local State (default):** Stored locally in a JSON format.
2. **Remote State:** stored on a remote source (Azure Storage, Artifactory, Terraform Enterprise, etc). It is best-suited for large or distributed teams

## How to

### Create Azure Storage Account

In the Portal, create a Storage Account, this storage account will act as the backend for Terraform State. You can get detailed information on how to create an Storage account [here](https://docs.microsoft.com/en-us/azure/storage/common/storage-quickstart-create-account?tabs=azure-portal).

After you are done, get the account information, including SAS token.

Create a Blob Container as described [here] (https://docs.microsoft.com/en-us/azure/storage/blobs/storage-quickstart-blobs-portal#create-a-container)

### Configure the Storage Account as Terraform Backend

Update your configuration with the info:

```hcl
terraform {
    backend {
        account = ""
        key = ""
        name = ""
    }
}
```

Run `terraform init`.

### View Lock State

Run a plan and view the file in the portal, notice how a lease is put on it.

What's next?
==============

Once this section is completed, go back to [the agenda](../../README.md).