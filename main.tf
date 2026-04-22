provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "network" {
  name     = "rg-enterprise-network"
  location = "East US"
}

module "hub" {
  source              = "./modules/hub"
  resource_group_name = azurerm_resource_group.network.name
  location            = azurerm_resource_group.network.location
  hub_vnet_name       = "vnet-hub-core"
  hub_vnet_address_space = "10.0.0.0/16"
  gateway_subnet_prefix  = "10.0.1.0/24"
  firewall_subnet_prefix = "10.0.2.0/24"
  mgmt_subnet_prefix     = "10.0.3.0/24"
}

module "spoke_prod" {
  source              = "./modules/spoke"
  resource_group_name = azurerm_resource_group.network.name
  location            = azurerm_resource_group.network.location
  spoke_vnet_name     = "vnet-spoke-prod"
  spoke_vnet_address_space = "10.1.0.0/16"
  app_subnet_prefix        = "10.1.1.0/24"
  data_subnet_prefix       = "10.1.2.0/24"
}

# VNet Peering: Hub to Spoke
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "peering-hub-to-prod"
  resource_group_name       = azurerm_resource_group.network.name
  virtual_network_name      = module.hub.vnet_name
  remote_virtual_network_id = module.spoke_prod.vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

# VNet Peering: Spoke to Hub
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "peering-prod-to-hub"
  resource_group_name       = azurerm_resource_group.network.name
  virtual_network_name      = module.spoke_prod.vnet_name
  remote_virtual_network_id = module.hub.vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}
