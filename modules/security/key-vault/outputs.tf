output "key_vault_id" {
  value = azurerm_key_vault.kv.id
}

output "key_vault_uri" {
  value = azurerm_key_vault.kv.vault_uri
}

output "secret_id" {
  value = azurerm_key_vault_secret.secret.id
}

output "secret_name" {
  value = azurerm_key_vault_secret.secret.name
}

output "key_vault_secrets_user_role_assignment_id" {
  value = azurerm_role_assignment.key_vault_secrets_user.id
}
