variable "resource_group_name" {
  type        = string
  description = "Name of the resource group where the Key Vault will be created."
}

variable "location" {
  type        = string
  description = "Azure location for the Key Vault."
}

variable "key_vault_name" {
  type        = string
  description = "Name of the Azure Key Vault instance."
}

variable "sku_name" {
  type        = string
  description = "SKU name for the Key Vault."
  default     = "standard"
}

variable "secret_name" {
  type        = string
  description = "Name of the Key Vault secret to create."
}

variable "secret_value" {
  type        = string
  description = "Value for the Key Vault secret."
  sensitive   = true
}

variable "spn_object_id" {
  type        = string
  description = "Object ID of the service principal that should receive Key Vault Secrets User permissions."
}

variable "tags" {
  type        = map(string)
  description = "Tags to assign to the Key Vault."
  default     = {}
}
variable "key_vault_tags" {
  type        = map(string)
  description = "Tags to attach to Key Vault resources."
  default     = {}
}