variable "env" {
    type = map
    default = {
        envName       = "wvddemo"
        region        = "centralus"
        keyvaultName  = "kv-wvddemo-centralus"
        keyvaultRG    = "hbl-wvddemo-centralus-management"
    }
}

# Configuration variables for session host VMs
variable "hostvm" {
    type    = map
    default = {
        # Azure VM Sku Size
        vmSize          = "Standard_D2s_v3"    
        # Image publisher         
        publisher       = "MicrosoftWindowsDesktop"    
        # Image offer 
        offer           = "Windows-10"          
        # Image offer sku        
        sku             = "19h2-evd"                    
        # VM OS disk size (GB)
        osDiskSizeGB    = 128
        # VM Local Administrator 
        adminUserName   = "wvdtestadmin"
        # AD DS domain name
        addsDomain      = "lab.thehibbs.net"
        # VNet Name
        vnetName        = "vnet-hbl-airs-demo-core-centralus"
        # VNet Resource Group name
        vnetRg          = "hbl-demo-network"
        # VNet Subnet name
        subnetName      = "sn-hbl-airs-demo-core-centralus-wvd"
    }
}
