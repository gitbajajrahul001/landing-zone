locals {
  standard_suffix          = "payg-001"
  non-standard_suffix      = "payg001"
  law_prefix               = "law"
  vnet_prefix              = "vnet"
  subnet_prefix            = "snet"
  linux_vm_prefix          = "linux-vm"
  windows_vm_prefix        = "win-vm"
  key_vault_prefix         = "kv"
  key_vault_secret_prefix  = "secret"
  dcr_prefix               = "dcr-agent"
  storage_account_prefix   = "st"
  storage_container_prefix = "st-container"

  linux_perf_counters = [
    "Memory\\% Used Memory",
    "Memory\\Available MBytes Memory"
  ]

  windows_perf_counters = [
    "\\Memory\\% Committed Bytes In Use",
    "\\Memory\\Available MBytes"
  ]

}

