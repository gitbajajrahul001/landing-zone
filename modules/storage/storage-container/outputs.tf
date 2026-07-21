output "id" {
  description = "Blob Container Resource ID."
  value       = azurerm_storage_container.this.id
}

output "name" {
  description = "Blob Container name."
  value       = azurerm_storage_container.this.name
}
