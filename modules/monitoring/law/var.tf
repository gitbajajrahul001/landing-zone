variable "workspace_name" {
  description = "Name of the Log Analytics Workspace."
  type        = string
}

variable "location" {
  description = "Azure region for the Log Analytics Workspace."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group in which to create the Log Analytics Workspace."
  type        = string
}
