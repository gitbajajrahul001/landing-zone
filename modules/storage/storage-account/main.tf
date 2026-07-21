resource "azurerm_storage_account" "storage-account" {
  name                     = var.account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location

  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  account_kind             = var.account_kind
  access_tier              = var.account_tier == "Standard" ? var.access_tier : null

  https_traffic_only_enabled      = var.https_traffic_only_enabled
  min_tls_version                 = var.min_tls_version
  public_network_access_enabled   = var.public_network_access_enabled
  shared_access_key_enabled       = var.shared_access_key_enabled
  allow_nested_items_to_be_public = var.allow_nested_items_to_be_public

  is_hns_enabled = var.is_hns_enabled

  dynamic "identity" {
    for_each = var.identity_enabled ? [1] : []
    content {
      type = "SystemAssigned"
    }
  }

  blob_properties {

    versioning_enabled = var.blob_versioning_enabled

    delete_retention_policy {
      days = var.blob_delete_retention_days
    }

    container_delete_retention_policy {
      days = var.container_delete_retention_days
    }
  }

  tags = var.tags
}