provider "azurerm" {
  features {}
}

# Define Variables for Region
variable "location" {
  default = "East US"
}

# Create Resource Groups for each VNet
resource "azurerm_resource_group" "vnet1_rg" {
  name     = "vnet1-rg"
  location = var.location
}

resource "azurerm_resource_group" "vnet2_rg" {
  name     = "vnet2-rg"
  location = var.location
}

resource "azurerm_resource_group" "vnet3_rg" {
  name     = "vnet3-rg"
  location = var.location
}

resource "azurerm_resource_group" "vnet4_rg" {
  name     = "vnet4-rg"
  location = var.location
}

# VNet and Subnet Creation using Modules

# VNet1
module "vnet1" {
  source  = "./modules/vnet"
  vnet_name = "vnet1"
  resource_group_name = azurerm_resource_group.vnet1_rg.name
  address_space = ["10.0.0.0/22"]
  location = azurerm_resource_group.vnet1_rg.location

  subnets = [
    {
      name           = "subnet1"
      address_prefix = "10.0.0.0/26"
    }
  ]
}

# VNet2
module "vnet2" {
  source  = "./modules/vnet"
  vnet_name = "vnet2"
  resource_group_name = azurerm_resource_group.vnet2_rg.name
  address_space = ["10.1.0.0/14"]
  location = azurerm_resource_group.vnet2_rg.location

  subnets = [
    {
      name           = "subnet1"
      address_prefix = "10.1.0.0/16"
    },
    {
      name           = "subnet2"
      address_prefix = "10.2.0.0/16"
    },
    {
      name           = "subnet3"
      address_prefix = "10.1.255.0/24"
    }
  ]
}

# VNet3
module "vnet3" {
  source  = "./modules/vnet"
  vnet_name = "vnet3"
  resource_group_name = azurerm_resource_group.vnet3_rg.name
  address_space = ["10.3.0.0/24"]
  location = azurerm_resource_group.vnet3_rg.location

  subnets = [
    {
      name           = "subnet1"
      address_prefix = "10.3.0.0/24"
    }
  ]
}

# VNet4
module "vnet4" {
  source  = "./modules/vnet"
  vnet_name = "vnet4"
  resource_group_name = azurerm_resource_group.vnet4_rg.name
  address_space = ["10.4.0.0/24"]
  location = azurerm_resource_group.vnet4_rg.location

  subnets = [
    {
      name           = "subnet1"
      address_prefix = "10.4.0.0/24"
    }
  ]
}
