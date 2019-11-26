terraform init
terraform plan -target=azurerm_virtual_machine.main
terraform apply -target=azurerm_virtual_machine.main
