# Variables
variable "vnet_name" {}
variable "resource_group_name" {}
variable "address_space" {
  type = list(string)
}
variable "location" {}
variable "subnets" {
  type = list(object({
    name           = string
    address_prefix = string
  }))
}

# VNet Creation
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space
}

# Subnet Creation
resource "azurerm_subnet" "subnet" {
  for_each            = { for subnet in var.subnets : subnet.name => subnet }
  name                = each.value.name
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes    = [each.value.address_prefix]
}
