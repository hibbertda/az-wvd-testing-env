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

output "wvd-hostpool-name" {
    value = azurerm_virtual_desktop_host_pool.hostpool.name
}

output "wvd-hostpool-regkey" {
    value = azurerm_virtual_desktop_host_pool.hostpool.registration_info[0].token
}