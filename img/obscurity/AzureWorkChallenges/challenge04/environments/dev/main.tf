module "myawesomeakscluster" {
  source   = "../../modules/my_aks_cluster"
  aks_name = "awesomeaks"
  vm_size  = "Standard_D2_v2"
  node_count = 2
  environment = var.environment
  clustercount = 2
}

module "differentakscluster" {
  source   = "../../modules/my_aks_cluster"
  aks_name = "differentaks"
  vm_size  = "Standard_A2_v2"
  node_count = 1
  environment = var.environment
}