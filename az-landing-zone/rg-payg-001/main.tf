resource "azurerm_resource_group" "rg-payg-001" {
  name     = "rg-payg-001"
  location = "Central India"
}

module "law_workspace" {
  source = "../../modules/monitoring/law"

  workspace_name      = "${local.law_prefix}-${local.standard_suffix}"
  location            = azurerm_resource_group.rg-payg-001.location
  resource_group_name = azurerm_resource_group.rg-payg-001.name
}

module "vnet" {
  source              = "../../modules/network/vnet"
  vnet_name           = "${local.vnet_prefix}-${local.standard_suffix}"
  location            = azurerm_resource_group.rg-payg-001.location
  resource_group_name = azurerm_resource_group.rg-payg-001.name
  address_space       = ["192.168.1.0/24"]
}

module "subnets" {
  source               = "../../modules/network/subnet"
  resource_group_name  = azurerm_resource_group.rg-payg-001.name
  virtual_network_name = module.vnet.name
  subnets = [
    {
      name             = "${local.subnet_prefix}-web-${local.standard_suffix}"
      address_prefixes = ["192.168.1.0/27"]
    },
    {
      name             = "${local.subnet_prefix}-app-${local.standard_suffix}"
      address_prefixes = ["192.168.1.32/27"]
    },
    {
      name             = "${local.subnet_prefix}-db-${local.standard_suffix}"
      address_prefixes = ["192.168.1.64/27"]
    },
    {
      name             = "${local.subnet_prefix}-pe-${local.standard_suffix}"
      address_prefixes = ["192.168.1.128/26"]
    },
  ]
}

module "linux_vm" {
  source              = "../../modules/compute/linux_vm"
  resource_group_name = azurerm_resource_group.rg-payg-001.name
  location            = azurerm_resource_group.rg-payg-001.location
  vm_name             = "${local.linux_vm_prefix}-${local.standard_suffix}"
  subnet_id           = module.subnets.subnet_ids["${local.subnet_prefix}-web-${local.standard_suffix}"]
  admin_username      = "provider"
  admin_password      = "Comnet@123456"
  vm_size             = "Standard_D2as_v4"
  image_publisher     = "Canonical"
  image_offer         = "ubuntu-24_04-lts"
  image_sku           = "server"
  image_version       = "latest"
  security_type       = "Standard"
  availability_option = "None"
  tags = {
    cost-center = "payg"
    owner       = "bajajrahul001@gmail.com"
  }
}

module "key_vault" {
  source              = "../../modules/security/key-vault"
  resource_group_name = azurerm_resource_group.rg-payg-001.name
  location            = azurerm_resource_group.rg-payg-001.location
  key_vault_name      = "${local.key_vault_prefix}-${local.standard_suffix}"
  secret_name         = "${local.key_vault_secret_prefix}-${local.standard_suffix}"
  secret_value        = var.key_vault_secret_value
  spn_object_id       = var.spn_object_id
}


module "dcr_agent_perf" {
  source                        = "../../modules/monitoring/dcr"
  resource_group_name           = azurerm_resource_group.rg-payg-001.name
  location                      = azurerm_resource_group.rg-payg-001.location
  dcr_name                      = "${local.dcr_prefix}-${local.standard_suffix}"
  workspace_resource_id         = module.law_workspace.workspace_id
  counters                      = ["Memory\\% Used Memory", "Memory\\Available MBytes Memory"] # CHANGED: Windows-style paths -> Linux-style (target is module.linux_vm)
  sampling_frequency_in_seconds = 900
  resource_to_associate         = module.linux_vm.vm_id
  tags = {
    created_by = "terraform"
  }
}


module "storage_account" {
  source = "../../modules/storage/storage-account"

  resource_group_name = azurerm_resource_group.rg-payg-001.name
  location            = azurerm_resource_group.rg-payg-001.location

  account_name             = "${local.storage_account_prefix}${local.non-standard_suffix}"
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  access_tier                     = "Hot"
  https_traffic_only_enabled      = true
  public_network_access_enabled   = true
  shared_access_key_enabled       = true
  allow_nested_items_to_be_public = false
  is_hns_enabled                  = false

  identity_enabled = false

  blob_versioning_enabled         = false
  blob_delete_retention_days      = 7
  container_delete_retention_days = 7

  tags = {
    cost-center = "payg"
    owner       = "bajajrahul001@gmail.com"
  }
}

module "storage_container-1" {
  source = "../../modules/storage/storage-container"

  storage_account_id    = module.storage_account.id
  container_name        = "vm-knowledge-${local.standard_suffix}"
  container_access_type = "private"
}

module "storage_container-2" {
  source = "../../modules/storage/storage-container"

  storage_account_id    = module.storage_account.id
  container_name        = "rg-knowledge-${local.standard_suffix}"
  container_access_type = "private"
}
module "storage_container-3" {
  source = "../../modules/storage/storage-container"

  storage_account_id    = module.storage_account.id
  container_name        = "sub-knowledge-${local.standard_suffix}"
  container_access_type = "private"
}
module "storage_container-4" {
  source = "../../modules/storage/storage-container"

  storage_account_id    = module.storage_account.id
  container_name        = "estate-knowledge-${local.standard_suffix}"
  container_access_type = "private"
}

