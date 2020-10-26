variable "rgLocation" {
    type = string
}

variable "rgName" {
    type = string
}

variable "env" {
    type = map
}

# Keyvault ID to store host pool registration key 
# variable "keyvault_id" {
#     type = string
# }

# Lifetime for WVD hostpool registration key (max 30days)
variable "registrationKeyLifetime" {
    type = number
    default = 12
}