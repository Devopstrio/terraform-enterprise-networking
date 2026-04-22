variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "hub_vnet_name" { type = string }
variable "hub_vnet_address_space" { type = string }
variable "gateway_subnet_prefix" { type = string }
variable "firewall_subnet_prefix" { type = string }
variable "mgmt_subnet_prefix" { type = string }
variable "spoke_vnet_name" { type = string default = "" }
variable "spoke_vnet_address_space" { type = string default = "" }
variable "app_subnet_prefix" { type = string default = "" }
variable "data_subnet_prefix" { type = string default = "" }
