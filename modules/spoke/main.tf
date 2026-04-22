resource "azurerm_virtual_network" "spoke" {
  name                = var.spoke_vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.spoke_vnet_address_space]
}

resource "azurerm_subnet" "app" {
  name                 = "snet-app"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [var.app_subnet_prefix]
}

resource "azurerm_subnet" "data" {
  name                 = "snet-data"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [var.data_subnet_prefix]
}

resource "azurerm_network_security_group" "spoke_nsg" {
  name                = "nsg-${var.spoke_vnet_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
}

# Basic production guardrail: Deny all inbound from Internet
resource "azurerm_network_security_rule" "deny_internet" {
  name                        = "DenyInternetInbound"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.spoke_nsg.name
}
