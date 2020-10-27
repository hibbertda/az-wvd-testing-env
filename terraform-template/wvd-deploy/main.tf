provider "azurerm" {
    features {}
}

terraform {
backend "azurerm" {
    resource_group_name     = "hbl-demo-env"
    storage_account_name    = "hblwvdterrstate"
    container_name          = "wvdstate"
    key                     = "wvdstate.tfstate"
    }
}

data "azurerm_client_config" "current" {}

data "azurerm_key_vault" "wvd-kv" {
    name = var.env["keyvaultName"]
    resource_group_name = var.env["keyvaultRG"]
}

# Create wvd front-end resource group
resource "azurerm_resource_group" "wvd-demo" {
    name        = "hbl-${var.env["envName"]}-${var.env["region"]}-frontend"
    location    =  var.env["region"]
}

# Create WVD Workspace
module "wvd_workspace" {
    source      = "./modules/wvd_workspace"
    rgLocation  = azurerm_resource_group.wvd-demo.location
    rgName      = azurerm_resource_group.wvd-demo.name
    env         = var.env
}

# Create WVD host pool
module "wvd_hostpool_developers" {
    source      = "./modules/wvd_hostpool"
    rgLocation  = azurerm_resource_group.wvd-demo.location
    rgName      = azurerm_resource_group.wvd-demo.name
    env         = var.env
}

# Create WVD session hosts
module "wvd_session_hosts" {
    env                 = var.env    
    source              = "./modules/wvd_sessionhosts"
    keyvault_id         = data.azurerm_key_vault.wvd-kv.id
    sessionHostCount    = 2
    network             = var.network
    hostvm              = var.hostvm
    adds-join           = var.adds-join
    wvd-hostpool-name   = module.wvd_hostpool_developers.wvd-hostpool-name
    wvd-hostpool-regkey = module.wvd_hostpool_developers.wvd-hostpool-regkey
}