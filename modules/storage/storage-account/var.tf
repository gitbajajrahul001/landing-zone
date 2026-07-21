variable "resource_group_name" {
  description = "Resource Group where the Storage Account will be deployed."
  type        = string
}

variable "location" {
  description = "Azure region for the Storage Account."
  type        = string
}

variable "account_name" {
  description = "Globally unique Storage Account name."
  type        = string
}

variable "account_kind" {
  description = "Storage Account kind."
  type        = string
  default     = "StorageV2"
}

variable "account_tier" {
  description = "Storage Account performance tier."
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "Storage replication type."
  type        = string
  default     = "LRS"
}

variable "access_tier" {
  description = "Default blob access tier."
  type        = string
  default     = "Hot"
}

variable "https_traffic_only_enabled" {
  description = "Allow only HTTPS traffic."
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "Enable public network access."
  type        = bool
  default     = true
}

variable "shared_access_key_enabled" {
  description = "Enable shared key authentication."
  type        = bool
  default     = true
}

variable "allow_nested_items_to_be_public" {
  description = "Allow blobs/containers to be publicly accessible."
  type        = bool
  default     = false
}

variable "is_hns_enabled" {
  description = "Enable Hierarchical Namespace (Data Lake Gen2)."
  type        = bool
  default     = false
}

variable "identity_enabled" {
  description = "Enable System Assigned Managed Identity."
  type        = bool
  default     = false
}

variable "blob_versioning_enabled" {
  description = "Enable blob versioning."
  type        = bool
  default     = false
}

variable "blob_delete_retention_days" {
  description = "Retention period for deleted blobs."
  type        = number
  default     = 7
}

variable "container_delete_retention_days" {
  description = "Retention period for deleted containers."
  type        = number
  default     = 7
}

variable "min_tls_version" {
  description = "Minimum supported TLS version."
  type        = string
  default     = "TLS1_2"
}

variable "tags" {
  description = "Tags applied to the Storage Account."
  type        = map(string)
  default     = {}
}