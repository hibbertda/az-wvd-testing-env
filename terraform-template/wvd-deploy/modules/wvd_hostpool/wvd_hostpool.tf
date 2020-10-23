resource "azurerm_virtual_desktop_host_pool" "hostpool"{
    location            = var.rgLocation
    resource_group_name = var.rgName

    name = "wvdhp-${var.env["envName"]}"
    friendly_name = "wvdhp-${var.env["envName"]}"
    description = "Development workstations"
    type = "Pooled"
    maximum_sessions_allowed = 5
    load_balancer_type = "DepthFirst"

    registration_info {
        expiration_date = timeadd(timestamp(), "${var.registrationKeyLifetime}h")
    }
}

# Output the hostpool registration key to WVD keyvault
resource "azurerm_key_vault_secret" "wvdhostkey" {
    name = "hostpool-registration-key"
    value = azurerm_virtual_desktop_host_pool.hostpool.registration_info[0].token

    key_vault_id = var.keyvault_id
    
    #Set secret expiration date to match registration key lifetime
    expiration_date = timeadd(timestamp(), "${var.registrationKeyLifetime}h")
}

output "wvd-hostpool-name" {
    value = azurerm_virtual_desktop_host_pool.hostpool.name
}