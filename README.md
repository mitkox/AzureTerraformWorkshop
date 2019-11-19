About this Workshop
========
This is a Workshop for *Terraform on Azure*.

Infrastructure as Code allows the management of your infrastructure including networks, virtual machines, platform services, and load balancers. Using Terraform configuration to describe the desired Azure resources needed for an environment ensures that consistent infrastructure is created each time it is deployed.

This Workshop is focused on:

- Understanding Infrastructure as Code concepts
- Terraform as an Infrastructure as Code provider for Azure
- Integratinf Terraform on Azure DevOps tooling.

Attendees will learn basics of Infrastructure as Code  and gain skills on deploying and managing Azure resources using Terraform.

Practical examples in this workshop include the creation of some basic Azure Resouces, however many others can be deployed using available Terraform resources.

###  Target audience

* Sysadmins
* Infrastructure architects
* DevOps Engineers
* SRE

### Attendee pre-requisites

* Basic understanding of command line
* No previous Azure experience required

If you have no previous experience on Azure and want to read an overview, access this link:

* [Azure Basis](azurebasis.md)

Presentation
============

The Power Point presentations used can be found: [AzureTerraformWorkshopPresentation](docs/AzureTerraformWorkshopPresentation.pptx)



Challenges
====

These are the challenges for the workshop, it is important to note that they have to be done in order of appearance

* [Challenge 00 - Getting Started](challenges/00-gettingstarted)
* [Challenge 01 - Connecting to Azure](challenges/01-connectingtoazure)
* [Challenge 02 - Creating an Azure Virtual Machine](challenges/02-azurevm)
* [Challenge 03 - Terraform Count](challenges/03-terraformcount)
* [Challenge 04 - Terraform Modules](challenges/04-terraformmodules)
* [Challenge 05 - Public Module Registry](challenges/05-publicmoduleregistry)
* [Challenge 06 - Private Module Registry](challenges/06-privatemoduleregistry)
* [Challenge 07 - Remote Backend](challenges/07-remotebackend)
* [Challenge 08 - Security](challenges/08-security)
* [Challenge 09 - Azure DevOps](challenges/09-azuredevops)


### Challenges requirements

This workshop will require that you have access to an Azure Subscription with at least Contributor rights to create resources and the ability to generate a service principal for the subscription (you need permissions on you Azure AD tenant). If you do not currently have access you can create a trial account by going to [https://azure.microsoft.com/en-us/free](https://azure.microsoft.com/en-us/free) and registering for a 3-month trail.

Signing up for a trial requires:

- A unique Microsoft Live Account that has not registered for a trial for in the past. It is recommended that you do NOT use your corporate email.
- A Credit Card, used to verify identity and will not be charged unless you opt-in after the trial is over

> If you are having issues with this access, please alert the instructor ASAP as this will prevent you from completing the challenges.

Credits
=======

This workshop has been created by:

* [Philippe Zenhaeusern](https://github.com/Zenocolo)- Microsoft
* [Laura Nicolas](https://github.com/lanicola)- Microsoft

Forked from the repo
* [Chris Matteson](https://github.com/chrismatteson/AzureTerraformWorkshop) - Hashicorp

Additional Resources
=======

Additional Resources can be found at: 
- Terraform Hub: https://docs.microsoft.com/en-us/azure/terraform/
- Terraform Azure Provider: https://www.terraform.io/docs/providers/azurerm
- Terraform Version Switcher: https://github.com/kamatama41/tfenv 
- Azure DevOps: https://docs.microsoft.com/en-us/azure/devops/index?view=azure-devops&viewFallbackFrom=vsts 