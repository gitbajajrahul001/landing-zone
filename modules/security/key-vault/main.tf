data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                        = var.key_vault_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = var.sku_name
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  rbac_authorization_enabled   = true
  enabled_for_disk_encryption = false
  enabled_for_deployment      = false
  enabled_for_template_deployment = false

  network_acls {
    bypass             = "AzureServices"
    default_action     = "Allow"
  }

  tags = var.tags
}

resource "azurerm_key_vault_secret" "secret" {
  name         = var.secret_name
  value        = var.secret_value
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_role_assignment" "key_vault_secrets_user" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = var.spn_object_id
  depends_on           = [azurerm_key_vault.kv]
}
