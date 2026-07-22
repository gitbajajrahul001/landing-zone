resource "azurerm_resource_group" "rg-payg-001" {
  name     = "rg-payg-001"
  location = "Central India"
}

# -----------------------------------------------------------------------------
# Log Analytics Workspace
# Centralized workspace for collecting Azure Monitor logs, performance metrics,
# and telemetry from monitored resources.
# -----------------------------------------------------------------------------
module "law_workspace" {
  source = "../../modules/monitoring/law"

  workspace_name      = "${local.law_prefix}-${local.standard_suffix}"
  location            = azurerm_resource_group.rg-payg-001.location
  resource_group_name = azurerm_resource_group.rg-payg-001.name
}

# -----------------------------------------------------------------------------
# Virtual Network
# Creates the landing zone virtual network that hosts all application subnets.
# -----------------------------------------------------------------------------
module "vnet" {
  source              = "../../modules/network/vnet"
  vnet_name           = "${local.vnet_prefix}-${local.standard_suffix}"
  location            = azurerm_resource_group.rg-payg-001.location
  resource_group_name = azurerm_resource_group.rg-payg-001.name
  address_space       = ["192.168.1.0/24"]
}

# -----------------------------------------------------------------------------
# Subnets
# Creates workload-specific subnets for Web, Application, Database and
# Private Endpoint resources.
# -----------------------------------------------------------------------------
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

# -----------------------------------------------------------------------------
# Linux Virtual Machine
# Deploys an Ubuntu virtual machine into the Web subnet for application hosting
# and infrastructure testing.
# -----------------------------------------------------------------------------
module "linux_vm" {
  source              = "../../modules/compute/linux_vm"
  resource_group_name = azurerm_resource_group.rg-payg-001.name
  location            = azurerm_resource_group.rg-payg-001.location

  vm_name             = "${local.linux_vm_prefix}-1-${local.standard_suffix}"
  subnet_id           = module.subnets.subnet_ids["${local.subnet_prefix}-web-${local.standard_suffix}"]
  vm_size             = "Standard_D2as_v4"
  admin_password      = var.linux_admin_password
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


# -----------------------------------------------------------------------------
# Windows Virtual Machine
# Deploys a Windows Server VM into the Web subnet, same tier as the Linux
# pair, for parity testing of guest-level monitoring across OS types.
# -----------------------------------------------------------------------------
module "windows_vm" {
  source              = "../../modules/compute/windows_vm"
  resource_group_name = azurerm_resource_group.rg-payg-001.name
  location            = azurerm_resource_group.rg-payg-001.location

  vm_name             = "${local.windows_vm_prefix}-1-${local.standard_suffix}"
  subnet_id           = module.subnets.subnet_ids["${local.subnet_prefix}-web-${local.standard_suffix}"]
  vm_size             = "Standard_D2as_v4"
  admin_password      = var.windows_admin_password
  image_publisher     = "MicrosoftWindowsServer"
  image_offer         = "WindowsServer"
  image_sku           = "2022-datacenter-azure-edition"
  image_version       = "latest"
  security_type       = "Standard"
  availability_option = "None"
  tags = {
    cost-center = "payg"
    owner       = "bajajrahul001@gmail.com"
  }
}

# -----------------------------------------------------------------------------
# Azure Key Vault
# Securely stores secrets and assigns RBAC permissions to the deployment SPN
# for secret management.
# -----------------------------------------------------------------------------
module "key_vault" {
  source = "../../modules/security/key-vault"

  resource_group_name = azurerm_resource_group.rg-payg-001.name
  location            = azurerm_resource_group.rg-payg-001.location

  key_vault_name = "${local.key_vault_prefix}-${local.standard_suffix}"
  secret_name    = "${local.key_vault_secret_prefix}-${local.standard_suffix}"
  secret_value   = var.key_vault_secret_value

  spn_object_id = var.spn_object_id
}

# -----------------------------------------------------------------------------
# Azure Monitor Data Collection Rule
# Collects guest operating system performance counters from the Linux VM and
# sends them to the Log Analytics Workspace.
# -----------------------------------------------------------------------------

module "dcr_agent_perf_linux" {
  source = "../../modules/monitoring/dcr"

  resource_group_name = azurerm_resource_group.rg-payg-001.name
  location            = azurerm_resource_group.rg-payg-001.location

  dcr_name              = "${local.dcr_prefix}-linux-${local.standard_suffix}"
  kind                  = "Linux"
  workspace_resource_id = module.law_workspace.workspace_id

  # Linux format: ObjectName then backslash then CounterName, no leading backslash.
  counters = local.linux_perf_counters

  sampling_frequency_in_seconds = 300

  resources_to_associate = {
    linux_vm = module.linux_vm.vm_id
  }

  tags = {
    created_by = "terraform"
  }
}

module "dcr_agent_perf_windows" {
  source = "../../modules/monitoring/dcr"

  resource_group_name = azurerm_resource_group.rg-payg-001.name
  location            = azurerm_resource_group.rg-payg-001.location

  dcr_name              = "${local.dcr_prefix}-windows-${local.standard_suffix}"
  kind                  = "Windows"
  workspace_resource_id = module.law_workspace.workspace_id

  # Windows format: leading backslash, ObjectName, backslash, CounterName.
  counters = local.windows_perf_counters

  sampling_frequency_in_seconds = 300

  resources_to_associate = {
    windows_vm_1 = module.windows_vm.vm_id
  }

  tags = {
    created_by = "terraform"
  }
}


# -----------------------------------------------------------------------------
# Storage Account
# Central storage account used to host AI knowledge containers for the
# Cloud Optimization Advisor.
# -----------------------------------------------------------------------------
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

  is_hns_enabled   = false
  identity_enabled = false

  blob_versioning_enabled         = false
  blob_delete_retention_days      = 7
  container_delete_retention_days = 7

  tags = {
    cost-center = "payg"
    owner       = "bajajrahul001@gmail.com"
  }
}

# -----------------------------------------------------------------------------
# Knowledge Container
# Stores AI-generated knowledge and optimization insights related to
# Virtual Machines.
# -----------------------------------------------------------------------------
module "storage_container-1" {
  source = "../../modules/storage/storage-container"

  storage_account_id    = module.storage_account.id
  container_name        = "vm-knowledge-${local.standard_suffix}"
  container_access_type = "private"
}

# -----------------------------------------------------------------------------
# Resource Group Knowledge Container
# Stores AI-generated knowledge related to Resource Groups.
# -----------------------------------------------------------------------------
module "storage_container-2" {
  source = "../../modules/storage/storage-container"

  storage_account_id    = module.storage_account.id
  container_name        = "rg-knowledge-${local.standard_suffix}"
  container_access_type = "private"
}

# -----------------------------------------------------------------------------
# Subscription Knowledge Container
# Stores subscription-wide optimization knowledge and recommendations.
# -----------------------------------------------------------------------------
module "storage_container-3" {
  source = "../../modules/storage/storage-container"

  storage_account_id    = module.storage_account.id
  container_name        = "sub-knowledge-${local.standard_suffix}"
  container_access_type = "private"
}

# -----------------------------------------------------------------------------
# Estate Knowledge Container
# Stores consolidated cloud estate knowledge, inventory and optimization data
# across the Azure environment.
# -----------------------------------------------------------------------------
module "storage_container-4" {
  source = "../../modules/storage/storage-container"

  storage_account_id    = module.storage_account.id
  container_name        = "estate-knowledge-${local.standard_suffix}"
  container_access_type = "private"
}