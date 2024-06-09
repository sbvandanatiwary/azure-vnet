# data resource to gather information pre-existing resource 
/*data "tfe_outputs" "erg"{
 organization = "SabreADI"
 workspace = "Infraonazure"
}
*/
data "terraform_remote_state" "demo-ResourceGroup"{
      backend = "remote"
      config = {
      organization = "SabreADI"
      workspace = {
      name = "Infraonazure"
                  }
   }
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = "${random_pet.prefix.id}-rg"
}

# Virtual Network
resource "azurerm_virtual_network" "my_terraform_network" {
  name                = "${random_pet.prefix.id}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  #location            = data.terraform_remote_state.demo-ResourceGroup.output.myTFResourceGroupcc1.location
  resource_group_name = azurerm_resource_group.rg.name
  #resource_group_name = ata.terraform_remote_state.demo-ResourceGroup.output.myTFResourceGroupcc1.name
  output "rg_name" {
  description = "The name of the created subnet 2."
  value       = data.tfe_outputs.erg.values
  #sensitive = true
}
}



# Subnet 1
resource "azurerm_subnet" "my_terraform_subnet_1" {
  name                 = "subnet-1"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.my_terraform_network.name
  address_prefixes     = ["10.0.0.0/24"]
}

# Subnet 2
resource "azurerm_subnet" "my_terraform_subnet_2" {
  name                 = "subnet-2"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.my_terraform_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "random_pet" "prefix" {
  prefix = var.resource_group_name_prefix
  length = 1
}
