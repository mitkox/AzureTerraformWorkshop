resource "azurerm_resource_group" "rg" {
  name     = "challenge05-rg"
  location = "centralus"
}

module "aks" {
  source              = "Azure/aks/azurerm"
  resource_group_name = "challenge05-rg"
  cluster_log_analytics_workspace_name = "sjhdsajhdkjsahdjksahkdjhsajkd"
  prefix = "pcp"
  role_based_access_control_enabled = true
  depends_on = [ azurerm_resource_group.rg ]
}