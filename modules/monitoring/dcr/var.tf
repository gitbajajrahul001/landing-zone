variable "resource_group_name" {
  type        = string
  description = "Resource group for the Data Collection Rule."
}

variable "location" {
  type        = string
  description = "Location for the Data Collection Rule."
}

variable "dcr_name" {
  type        = string
  description = "Name for the Data Collection Rule."
}

variable "workspace_resource_id" {
  type        = string
  description = "Resource ID of the Log Analytics workspace destination."
}

variable "counters" {
  type        = list(string)
  description = "Performance counter specifiers to collect. IMPORTANT: format differs by OS. Linux counters have no leading backslash, e.g. 'Memory\\% Used Memory'. Windows counters do, e.g. '\\Memory\\% Committed Bytes In Use'. This DCR is kind=Linux, so use Linux-style specifiers only."
  default = [
    "Memory\\% Used Memory",
    "Memory\\Available MBytes Memory"
  ]
}

variable "sampling_frequency_in_seconds" {
  type        = number
  description = "Sampling frequency in seconds for performance counters."
  default     = 900
}
/*
variable "resource_to_associate" {
  type        = string
  description = "Resource ID of the VM/VMSS to associate the DCR with."
}
*/
variable "resources_to_associate" {
  description = "List of Azure resource IDs to associate with the DCR."
  type        = map(string)
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the DCR."
  default     = {}
}
