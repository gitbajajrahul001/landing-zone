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

variable "kind" {
  type        = string
  description = "OS scope for this DCR -- 'Linux' or 'Windows'. Determines which counter_specifier format and names are valid. Never mix OS types under one DCR."

  validation {
    condition     = contains(["Linux", "Windows"], var.kind)
    error_message = "kind must be 'Linux' or 'Windows'."
  }
}

variable "workspace_resource_id" {
  type        = string
  description = "Resource ID of the Log Analytics workspace destination."
}

variable "counters" {
  type        = list(string)
  description = "Performance counter specifiers to collect. Format is OS-dependent -- must match var.kind. Linux: no leading backslash, e.g. 'Memory\\% Used Memory'. Windows: leading backslash, e.g. '\\Memory\\% Committed Bytes In Use'. No default on purpose -- pick the right set at the call site for the kind you chose."
}

variable "sampling_frequency_in_seconds" {
  type        = number
  description = "Sampling frequency in seconds for performance counters."
  default     = 900
}

variable "resources_to_associate" {
  description = "Map of Azure resource IDs to associate with the DCR. Keys are arbitrary labels used in the association resource name."
  type        = map(string)
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the DCR."
  default     = {}
}
