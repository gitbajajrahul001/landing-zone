variable "vnet_name" {
  type        = string
  description = "Name of the virtual network"
}

variable "location" {
  type        = string
  description = "Azure location for the virtual network"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name where the virtual network will be created"
}

variable "address_space" {
  type        = list(string)
  description = "Address space for the virtual network"
}

variable "tags" {
  type        = map(string)
  description = "Tags to assign to the virtual network"
  default     = {}
}
