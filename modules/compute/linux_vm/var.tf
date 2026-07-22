variable "resource_group_name" {
  type        = string
  description = "Resource group name where the VM and NIC will be created."
}

variable "vm_name" {
  type        = string
  description = "Name of the virtual machine."
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
  description = "Admin username for the VM."
  default     = "provider"
}

variable "admin_password" {
  type        = string
  description = "Admin password for the VM."
  sensitive   = true
  default     = "Comnet@0987654321"
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
  default     = 30
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

variable "delete_nic_on_vm_delete" {
  type        = bool
  description = "Whether the NIC is deleted when the VM is deleted."
  default     = true
}

variable "enable_ultra_disk_compatibility" {
  type        = bool
  description = "Whether ultra disk compatibility is enabled on the VM."
  default     = false
}

variable "boot_diagnostics_enabled" {
  type        = bool
  description = "Whether boot diagnostics is enabled on the VM."
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
  description = "VM placement redundancy. 'None' = no redundancy construct. 'AvailabilityZone' = pin to a specific zone. 'AvailabilitySet' = create/join an availability set (fault + update domains)."
  default     = "None"

  validation {
    condition     = contains(["None", "AvailabilityZone", "AvailabilitySet"], var.availability_option)
    error_message = "availability_option must be one of: None, AvailabilityZone, AvailabilitySet."
  }
}

variable "availability_zone" {
  type        = string
  description = "Zone number ('1', '2', or '3') to pin the VM to. Only used when availability_option = 'AvailabilityZone'. Not every region/size combination supports every zone — validate against az vm list-skus before relying on this in a catalog item."
  default     = "1"
}

variable "availability_set_fault_domain_count" {
  type        = number
  description = "Fault domain count for the availability set. Only used when availability_option = 'AvailabilitySet'. Max varies by region (typically 2 or 3)."
  default     = 2
}

variable "availability_set_update_domain_count" {
  type        = number
  description = "Update domain count for the availability set. Only used when availability_option = 'AvailabilitySet'. Max is 20."
  default     = 5
}

variable "tags" {
  type        = map(string)
  description = "Tags to assign to the VM and NIC."
  default = {
    owner       = ""
    cost-center = ""
  }
}

