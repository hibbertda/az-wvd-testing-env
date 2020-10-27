data "azurerm_subnet" "wvd-subnet" {
    name                    = var.network["subnetName"]
    virtual_network_name    = var.network["vnetName"]
    resource_group_name     = var.network["vnetRg"]
}

data "azurerm_key_vault_secret" "hostvmadminusername" {
    name            = "vm-adminusername"
    key_vault_id    = var.keyvault_id
}

data "azurerm_key_vault_secret" "hostvm-admin-password" {
    name            = "vm-adminpassword"
    key_vault_id    = var.keyvault_id
}

data "azurerm_key_vault_secret" "domain-join-username" {
    name            = "domainjoin-username"
    key_vault_id    = var.keyvault_id
}

data "azurerm_key_vault_secret" "domain-join-password" {
    name            = "domainjoin-password"
    key_vault_id    = var.keyvault_id
}

resource "azurerm_resource_group" "wvd-hosts" {
    name        = "hbl-${var.env["envName"]}-${var.env["region"]}-sessionhosts"
    location    =  var.env["region"]
}

resource "azurerm_network_interface" "wvd-host-nic" {
    name                = "nic-wvdh-${var.env["envName"]}"
    location            = azurerm_resource_group.wvd-hosts.location
    resource_group_name = azurerm_resource_group.wvd-hosts.name

    ip_configuration {
        name                                = "nic-wvdh-${var.env["envName"]}-config"
        subnet_id                           = data.azurerm_subnet.wvd-subnet.id
        private_ip_address_allocation       = "Dynamic"
    }    
}

resource "azurerm_virtual_machine" "wvd-vm-host" {
    name                    = "vm-${var.env["envName"]}-${var.env["region"]}-win10"
    location                = azurerm_resource_group.wvd-hosts.location
    resource_group_name     = azurerm_resource_group.wvd-hosts.name
    network_interface_ids   = [azurerm_network_interface.wvd-host-nic.id]
    vm_size                 = var.hostvm["vmSize"]

    storage_image_reference {
        publisher   = var.hostvm["publisher"]
        offer       = var.hostvm["offer"]
        sku         = var.hostvm["sku"]
        version     = "latest"
    }

    storage_os_disk {
        name                = "vm-${var.env["envName"]}-${var.env["region"]}-win10-osDisk"
        caching             = "ReadWrite"
        create_option       = "FromImage"
        managed_disk_type   = "Standard_LRS"
        disk_size_gb        = var.hostvm["osDiskSizeGB"]
    }

    os_profile {
        computer_name   = "vm-${var.env["envName"]}"
        admin_username  = data.azurerm_key_vault_secret.hostvmadminusername.value
        admin_password  = data.azurerm_key_vault_secret.hostvm-admin-password.value
    }

    os_profile_windows_config {
        provision_vm_agent  = true
    }
}

# Add Virtual Machine to AD DS Domain
resource "azurerm_virtual_machine_extension" "domainJoin" {
  name                       = "vm-${var.env["envName"]}-domainJoin"
  virtual_machine_id         = azurerm_virtual_machine.wvd-vm-host.id
  publisher                  = "Microsoft.Compute"
  type                       = "JsonADDomainExtension"
  type_handler_version       = "1.3"
  auto_upgrade_minor_version = true
  #depends_on                 = ["azurerm_virtual_machine_extension.LogAnalytics"]

  lifecycle {
    ignore_changes = [
      settings,
      protected_settings,
    ]
  }

  settings = <<SETTINGS
    {
        "Name": "${var.adds-join["domainName"]}",
        "User": "${data.azurerm_key_vault_secret.domain-join-username.value}",
        "Restart": "true",
        "Options": "3"
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
  {
         "Password": "${data.azurerm_key_vault_secret.domain-join-password.value}"
  }
PROTECTED_SETTINGS
}