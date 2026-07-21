variable "resource_group_name" {
  type        = string
  description = "Resource group name where the subnet will be created"
}

variable "virtual_network_name" {
  type        = string
  description = "Name of the virtual network the subnet belongs to"
}

variable "subnets" {
  type = list(object({
    name              = string
    address_prefixes  = list(string)
    #service_endpoints = optional(list(string), [])
    #tags              = optional(map(string), {})
  }))
  description = "List of subnet definitions to create under the virtual network"
}
