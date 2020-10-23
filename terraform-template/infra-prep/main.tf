# Create KeyVault resource for WVD deployment
provider "azurerm" {
    features {}
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "wvd-demo" {
    name        = "hbl-${var.env["envName"]}-${var.env["region"]}-management"
    location    =  var.env["region"]
}

# Create KeyVault and grant current user with access policy to manage secrets
resource "azurerm_key_vault" "wvd-keyvault" {
    name                        = "kv-${var.env["envName"]}-${var.env["region"]}"
    location                    = azurerm_resource_group.wvd-demo.location
    resource_group_name         = azurerm_resource_group.wvd-demo.name
    tenant_id                   = data.azurerm_client_config.current.tenant_id
    enabled_for_disk_encryption = false
    sku_name                    = "standard"

    access_policy {
        tenant_id               = data.azurerm_client_config.current.tenant_id
        object_id               = data.azurerm_client_config.current.object_id

        secret_permissions  = [
            "get",
            "list",
            "purge",
            "recover",
            "restore",
            "backup",
            "set",
            "delete"
        ]
    }

}

# Output vm-admin password secret
resource "azurerm_key_vault_secret" "adminPassword" {
    name = "vm-adminpassword"
    value = ""

    key_vault_id = azurerm_key_vault.wvd-keyvault.id
}

# Output vm-admin username secret
resource "azurerm_key_vault_secret" "adminusername" {
    name = "vm-adminusername"
    value = ""

    key_vault_id = azurerm_key_vault.wvd-keyvault.id
}

# Output domain-join username secret
resource "azurerm_key_vault_secret" "domainjoin-username" {
    name = "domainjoin-username"
    value = ""

    key_vault_id = azurerm_key_vault.wvd-keyvault.id
}

# Output domain-join password secret
resource "azurerm_key_vault_secret" "domainjoin-password" {
    name = "domainjoin-password"
    value = ""

    key_vault_id = azurerm_key_vault.wvd-keyvault.id
}

# Create host key secret
resource "azurerm_key_vault_secret" "wvd-host-key" {
    name = "hostpool-registration-key"
    value = ""

    key_vault_id = azurerm_key_vault.wvd-keyvault.id
}