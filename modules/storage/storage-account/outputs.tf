output "id" {
  description = "Storage Account Resource ID."
  value       = azurerm_storage_account.storage-account.id
}

output "name" {
  description = "Storage Account name."
  value       = azurerm_storage_account.storage-account.name
}

output "primary_blob_endpoint" {
  description = "Primary Blob endpoint."
  value       = azurerm_storage_account.storage-account.primary_blob_endpoint
}

output "primary_dfs_endpoint" {
  description = "Primary Data Lake endpoint."
  value       = azurerm_storage_account.storage-account.primary_dfs_endpoint
}

output "primary_file_endpoint" {
  description = "Primary File endpoint."
  value       = azurerm_storage_account.storage-account.primary_file_endpoint
}

output "primary_queue_endpoint" {
  description = "Primary Queue endpoint."
  value       = azurerm_storage_account.storage-account.primary_queue_endpoint
}

output "primary_table_endpoint" {
  description = "Primary Table endpoint."
  value       = azurerm_storage_account.storage-account.primary_table_endpoint
}

output "primary_web_endpoint" {
  description = "Primary Static Website endpoint."
  value       = azurerm_storage_account.storage-account.primary_web_endpoint
}
