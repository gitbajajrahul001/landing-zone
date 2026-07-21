variable "storage_account_id" {
  description = "Resource ID of the Storage Account."
  type        = string
}

variable "container_name" {
  description = "Name of the Blob Container."
  type        = string
}

variable "container_access_type" {
  description = "Public access level for the container."
  type        = string
  default     = "private"

  validation {
    condition = contains(
      ["private", "blob", "container"],
      var.container_access_type
    )

    error_message = "container_access_type must be one of: private, blob or container."
  }
}