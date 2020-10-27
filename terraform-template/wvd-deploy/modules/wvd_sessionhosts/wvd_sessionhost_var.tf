# Env variables
variable "env" {
    type = map
}
# Keyvault ID to store host pool registration key 
variable "keyvault_id" {
    type = string
}
# Count of VMs to create
variable "sessionHostCount" {
    type = number
    default = 2
}
# Network information
variable "network" {
    type = map
}

# Virtual Machine Configuration
variable "hostvm" {
    type = map
}

variable "wvd-hostpool-name" {
    type = string
}

variable "wvd-hostpool-regkey" {
    type = string
}

variable "adds-join" {
    type = map
}