variable "resource_group_name" {
  type        = string
  description = "Resource group name where the VM and NIC will be created."
}

variable "vm_name" {
  type        = string
  description = "Name of the virtual machine. NetBIOS hostname limit is 15 characters for Windows -- longer names get silently truncated by the OS, not rejected by Terraform, so validate upstream."
}

variable "location" {
  type        = string
  description = "Azure region where the VM will be deployed."
}

variable "subnet_id" {
  type        = string
  description = "ID of the subnet where the NIC will be attached."
}

variable "admin_username" {
  type        = string
  description = "Admin username for the VM. Cannot be 'Administrator', 'admin', 'user', or similar reserved/disallowed names on Windows -- Azure rejects these at deploy time."
  default     = "vmadmin"
}

variable "admin_password" {
  type        = string
  description = "Admin password for the VM. No default on purpose -- supply via Key Vault or a var-file that is never committed. Must meet Windows complexity: 12-123 chars, 3 of (upper/lower/digit/special)."
  sensitive   = true
}

variable "vm_size" {
  type        = string
  description = "Azure VM size."
}

variable "image_publisher" {
  type        = string
  description = "Image publisher for the VM."
}

variable "image_offer" {
  type        = string
  description = "Image offer for the VM."
}

variable "image_sku" {
  type        = string
  description = "Image SKU for the VM."
}

variable "image_version" {
  type        = string
  description = "Image version for the VM."
}

variable "os_disk_size_gb" {
  type        = number
  description = "OS disk size in GB."
  default     = 127
}

variable "os_disk_type" {
  type        = string
  description = "OS disk storage account type."
  default     = "Standard_LRS"
}

variable "enable_accelerated_networking" {
  type        = bool
  description = "Whether accelerated networking is enabled on the NIC."
  default     = false
}

variable "security_type" {
  type        = string
  description = "VM security type. 'Standard' = no trusted launch. 'TrustedLaunch' = enables Secure Boot + vTPM. Requires a Gen2-compatible source image."
  default     = "Standard"

  validation {
    condition     = contains(["Standard", "TrustedLaunch"], var.security_type)
    error_message = "security_type must be either 'Standard' or 'TrustedLaunch'."
  }
}

variable "availability_option" {
  type        = string
  description = "VM placement redundancy. 'None' = no redundancy construct. 'AvailabilityZone' = pin to a specific zone."
  default     = "None"

  validation {
    condition     = contains(["None", "AvailabilityZone"], var.availability_option)
    error_message = "availability_option must be one of: None, AvailabilityZone."
  }
}

variable "availability_zone" {
  type        = string
  description = "Zone number ('1', '2', or '3') to pin the VM to. Only used when availability_option = 'AvailabilityZone'."
  default     = "1"
}

variable "license_type" {
  type        = string
  description = "Set to 'Windows_Server' to apply Azure Hybrid Benefit (requires eligible on-prem licensing with Software Assurance). Set to 'None' for pay-as-you-go Windows licensing baked into the compute rate."
  default     = "None"

  validation {
    condition     = contains(["None", "Windows_Server"], var.license_type)
    error_message = "license_type must be 'None' or 'Windows_Server'."
  }
}

variable "patch_mode" {
  type        = string
  description = "Guest patch orchestration mode. 'AutomaticByPlatform' delegates to Azure Update Manager."
  default     = "AutomaticByPlatform"
}

variable "patch_assessment_mode" {
  type        = string
  description = "Must align with patch_mode -- 'AutomaticByPlatform' or 'ImageDefault'."
  default     = "AutomaticByPlatform"
}

variable "enable_monitoring_agent" {
  type        = bool
  description = "Whether to install the Azure Monitor Windows Agent extension on this VM. Required if this VM will be associated with any Data Collection Rule."
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Tags to assign to the VM and NIC."
  default = {
    owner       = ""
    cost-center = ""
  }
}
