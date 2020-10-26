variable "env" {
    type = map
    default = {
        envName       = "wvddemo"
        region        = "centralus"
        keyvaultName  = "kv-wvddemo-centralus"
        keyvaultRG    = "hbl-wvddemo-centralus-management"
    }
}

variable "network" {
    type = map
    default = {
        vnetName    = "vnet-hbl-airs-demo-core-centralus"
        vnetRg      = "hbl-demo-network"
        subnetName  = "sn-hbl-airs-demo-core-centralus-wvd"
    }
}

variable "hostvm" {
    type    = map
    default = {
        vmSize          = "Standard_D2s_v3"
        publisher       = "MicrosoftWindowsDesktop"
        offer           = "Windows-10"
        sku             = "19h2-evd"
        osDiskSizeGB    = 128
        adminUserName   = "wvdtestadmin"
    }
}

# AD DS domain join vars

variable "adds-join" {
    type = map
    default = {
        domainName = "lab.thehibbs.net"
        
    }
}

